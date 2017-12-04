# Godot Console main script
# Copyright (c) 2016 Hugo Locurcio and contributors - MIT license

extends CanvasLayer
const Argument = preload('Argument.gd')
const BaseCommands = preload('BaseCommands.gd')

const Range = preload('Types/Range.gd')

onready var console_box = $ConsoleBox
onready var console_text = $ConsoleBox/ConsoleText
onready var console_line = $ConsoleBox/LineEdit
onready var animation_player = $ConsoleBox/AnimationPlayer

# Those are the scripts containing command and cvar code
var cmd_history = []
var cmd_history_count = 0
var cmd_history_up = 0

# All recognized commands
var commands = {}

# All recognized cvars
var cvars = {}

var g_player = null

# For tabbing commands :D
var prev_com = ""
var entered_latters = ""
var prev_entered_latters = ""
var text_changed_by_player = true
var found_commands_list = []
var is_tab_pressed = false


func _ready():
	# Allow selecting console text
	console_text.set_selection_enabled(true)
	# Follow console output (for scrolling)
	console_text.set_scroll_follow(true)
	# Don't allow focusing on the console text itself
	console_text.set_focus_mode(Control.FOCUS_NONE)

	set_process_input(true)

	animation_player.connect("animation_finished", self, "_on_AnimationPlayer_finished")
	console_line.connect("text_changed", self, "_on_LineEdit_text_changed")
	console_line.connect("text_entered", self, "_on_LineEdit_text_entered")

	animation_player.set_current_animation("fade")
	# HIDE CONSOLE OM START ^_^
	set_console_opened(true)
	console_box.hide()
	# By default we show help
	var v = Engine.get_version_info()
	append_bbcode(\
	 "Welcome in Godot Engine " + str(v.major) + '.' + str(v.minor) + '.' + str(v.patch) + ' ' + v.status+" console"\
	+"\nProject: " + ProjectSettings.get_setting("application/config/name")\
	+"\nType [color=yellow]cmdlist[/color] to get a list of all commands avaliables\n[color=green]===[/color]\n")

	# Register built-in commands
	BaseCommands.new()

func _input(event):
	if Input.is_action_just_pressed("console_toggle"):
		var opened = is_console_opened()
		if opened == 1:
			set_console_opened(false)
		elif opened == 0:
			set_console_opened(true)
	if Input.is_action_just_pressed("console_up"):
		if (cmd_history_up > 0 and cmd_history_up <= cmd_history.size()):
			cmd_history_up-=1
			console_line.set_text(cmd_history[cmd_history_up])
	if Input.is_action_just_pressed("console_down"):
		if (cmd_history_up > -1 and cmd_history_up + 1 < cmd_history.size()):
			cmd_history_up +=1
			console_line.set_text(cmd_history[cmd_history_up])

	if is_tab_pressed:
		is_tab_pressed = Input.is_key_pressed(KEY_TAB)
	if console_line.get_text() != "" and console_line.has_focus() and Input.is_key_pressed(KEY_TAB) and not is_tab_pressed:
		complete()
		is_tab_pressed = true

func complete():
	var text = entered_latters
	var last_match = ""

	if prev_entered_latters != entered_latters or found_commands_list.empty():
		found_commands_list = []
		# If there are no matches found yet, try to complete for a command or cvar
		for command in commands:
			if command.begins_with(text):
				describe_command(command)
				last_match = command
				found_commands_list.append(command)
		for cvar in cvars:
			if cvar.begins_with(text):
				describe_cvar(cvar)
				last_match = cvar
				found_commands_list.append(cvar)

	if found_commands_list.size()>0 and prev_com == "":
		prev_com = found_commands_list[0]
	var idx = found_commands_list.find(prev_com)
	if idx != -1:
		idx += 1
		if idx >= found_commands_list.size():
			idx = 0
		prev_com = found_commands_list[idx]
	else:
		prev_com = last_match

	if prev_com != "":
		# text_changed_by_player needs for not changing other vals by signal "text_changed"
		text_changed_by_player = false
		console_line.text = prev_com + " "
		text_changed_by_player = true
		console_line.set_cursor_position(prev_com.length()+1)
	prev_entered_latters = entered_latters

# This function is called from scripts/console_commands.gd to avoid the
# "Cannot access self without instance." error
func quit():
	get_tree().quit()

func set_console_opened(opened):
	# Close the console
	if opened == true:
		animation_player.play("fade")
		# Signal handles the hiding at the end of the animation
	# Open the console
	elif opened == false:
		animation_player.play_backwards("fade")
		console_box.show()
		console_line.grab_focus()
		console_line.clear()

# This signal handles the hiding of the console at the end of the fade-out animation
func _on_AnimationPlayer_finished(anim):
	if is_console_opened():
		console_box.hide()

# Is the console fully opened?
func is_console_opened():
	if animation_player.get_current_animation()!="":
		if animation_player.get_current_animation_position() == animation_player.get_current_animation_length():
			return 1
		elif animation_player.get_current_animation_position() == 0:
			return 0
		else:
			return 2
	return 0

# Called when player change text
func _on_LineEdit_text_changed(text):
	if text_changed_by_player:
		entered_latters = text

# Called when the user presses Enter in the console
func _on_LineEdit_text_entered(text):
	# used to manage cmd history
	if cmd_history.size() > 0:
		if (text != cmd_history[cmd_history_count - 1]):
			cmd_history.append(text)
			cmd_history_count+=1
	else:
		cmd_history.append(text)
		cmd_history_count+=1
	cmd_history_up = cmd_history_count
	var text_splitted = text.split(" ", false)
	# Don't do anything if the LineEdit contains only spaces
	if not text.empty() and text_splitted[0]:
		handle_command(text)
	else:
		# Clear the LineEdit but do nothing
		console_line.clear()

# Registers a new command
func register_command(name, args):
	if args.has("target") and args.target != null and args.has("args"):
		if args.target.has_method(name):
			var argsl = []
			for arg in args.args:
				argsl.append(Argument.new(arg[0], arg[1]))

			args.args = argsl

			commands[name] = args
		else:
			echo("[color=#ff8888][ERROR][/color] Failed adding command " + name + ". The target has no such function!")
	else:
		echo("[color=#ff8888][ERROR][/color] Failed adding command " + name + ". Invalid arguments!")

# Registers a new cvar (control variable)
func register_cvar(name, args):
	if args.has("target") and args.target != null and args.has("arg"):
		if args.target.get(name) != null:
			args.arg = Argument.new(args.arg[0], args.arg[1])
			cvars[name] = args
		else:
			echo("[color=#ff8888][ERROR][/color] Failed adding variable " + name + ". The target has no such variable!")
	else:
		echo("[color=#ff8888][ERROR][/color] Failed adding variable " + name + ". Invalid arguments!")

func append_bbcode(bbcode):
	console_text.set_bbcode(console_text.get_bbcode() + bbcode)

func get_history_str():
	var strOut = ""
	var count = 0
	for i in cmd_history:
		strOut += "[color=#ffff66]" + str(count) + ".[/color] " + i + "\n"
		count+=1

	return strOut

func clear():
	console_text.set_bbcode("")

# Describes a command, user by the "cmdlist" command and when the user enters a command name without any arguments (if it requires at least 1 argument)
func describe_command(cmd):
	var command = commands[cmd]
	var args = Argument.to_string(command.args)

	append_bbcode("[color=#ffff66]" + cmd + "[/color]")

	if command.args.size() >= 1:
		append_bbcode(" [color=#88ffff]" + args + "[/color]")

	if (command.has('description')):
		append_bbcode(' - ' + command.description)

	append_bbcode("\n")

# Describes a cvar, used by the "cvarlist" command and when the user enters a cvar name without any arguments
func describe_cvar(cvar):
	var cvariable = cvars[cvar]
	var arg = Argument.to_string([cvariable.arg])
	var value = cvariable.target.get(cvar)

	append_bbcode('[color=#88ff88]' + cvar + '[/color] [color=#88ffff]' + arg + '[/color]')

	if cvariable.has('description'):
		append_bbcode(' - ' + cvariable.description)

	append_bbcode(' ([color=#ff88ff]' + str(value) + '[/color])\n')

func handle_command(text):
	# The current console text, splitted by spaces (for arguments)
	var cmd = text.split(" ", false)
	# Check if the first word is a valid command
	if commands.has(cmd[0]):
		var command = commands[cmd[0]]

		var args = []
		var arg_status
		for i in range(1, cmd.size()):
			arg_status = command.args[i - 1].set_value(cmd[i])

			if arg_status == OK:
				args.append(command.args[i - 1].value)
			else:
				append_bbcode("[i][color=#ff8888]Some error that sais that method param number " + str(i) + " has different type[/color][/i]\n")
				return

		print("> " + text)
		append_bbcode("[b]> " + text + "[/b]\n")
		# Check target script argument
		# If no argument is supplied, then show command description and usage, but only if command has at least 1 argument required
		if arg_status == FAILED:
			describe_command(cmd[0])
		else:
			# Run the command!
			command.target.callv(cmd[0], args)

	# Check if the first word is a valid cvar
	elif cvars.has(cmd[0]):
		var cvar = cvars[cmd[0]]
		print("> " + text)
		append_bbcode("\n[b]> " + text + "[/b]\n")
		# Check target script argument
		# If no argument is supplied, then show cvar description and usage
		if cmd.size() == 1:
			describe_cvar(cmd[0])
		else:
			cvar.arg.set_value(cmd[1])

			# Call setter code
			cvar.target.set(cmd[0], cvar.arg.value)
	else:
		# Treat unknown commands as unknown
		append_bbcode("[b]> " + text + "[/b]\n")
		append_bbcode("[i][color=#ff8888]Unknown command or cvar: " + cmd[0] + "[/color][/i]\n")
	console_line.clear()

#######################################################################
##################_____STANDART_COMMMAND_LIST_____#####################
#######################################################################
func echo(text):
	# Erase "echo" from the output
	#text.erase(0, 5)
	append_bbcode(str(text) + "\n")
	print(text)

# Lists all available commands
func cmdlist():
	var commands = Console.commands
	for command in commands:
		Console.describe_command(command)

func history():
	Console.append_bbcode(Console.get_history_str())

# Lists all available cvars
func cvarlist():
	var cvars = Console.cvars
	for cvar in cvars:
		Console.describe_cvar(cvar)

# Prints some help
func help():
	var help_text = """Type [color=#ffff66]cmdlist[/color] to get a list of commands.
Type [color=#ffff66]quit[/color] to exit the application."""
	Console.append_bbcode(help_text + "\n")

func version(full = false):
	var v = Engine.get_version_info()
	if full:
		append_bbcode(str(v)+"\n")
	else:
		append_bbcode(str(v.major) + '.' + str(v.minor) + '.' + str(v.patch) + ' ' + v.status+"\n")
