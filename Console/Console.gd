# Godot Console main script
# Copyright (c) 2016 Hugo Locurcio and contributors - MIT license

extends Panel

onready var console_text = $ConsoleText
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
	console_text.set_focus_mode(FOCUS_NONE)

	set_process_input(true)
	
	$AnimationPlayer.set_current_animation("fade")
	# HIDE CONSOLE OM START ^_^
	set_console_opened(true)
	hide()
	# By default we show help
	append_bbcode("Welcome in Godot Engine debug console\nProject: " + ProjectSettings.get_setting("application/config/name") + "\nType [color=yellow]cmdlist[/color] to get a list of all commands avaliables\n[color=green]===[/color]\n")

	# Register built-in commands
	register_command("echo", {
		description = "Prints a string in console",
		args = "<string>",
		num_args = 1,
		target = self
	})

	register_command("history", {
		description = "Print all previous cmd used during the session",
		args = "",
		num_args = 0,
		target = self
	})

	register_command("cmdlist", {
		description = "Lists all available commands",
		args = "",
		num_args = 0,
		target = self
	})

	register_command("cvarlist", {
		description = "Lists all available cvars",
		args = "",
		num_args = 0,
		target = self
	})

	register_command("help", {
		description = "Outputs usage instructions",
		args = "",
		num_args = 0,
		target = self
	})

	register_command("quit", {
		description = "Exits the application",
		args = "",
		num_args = 0,
		target = self
	})

	register_command("clear", {
		description = "clear the terminal",
		args = "",
		num_args = 0,
		target = self
	})

	# Register built-in cvars
	register_cvar("client_max_fps", {
		description = "The maximal framerate at which the application can run",
		type = TYPE_INT,
		default_value = 61,
		min_value = 10,
		max_value = 1000,
		target = self
	})


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
			$LineEdit.set_text(cmd_history[cmd_history_up])
	if Input.is_action_just_pressed("console_down"):
		if (cmd_history_up > -1 and cmd_history_up + 1 < cmd_history.size()):
			cmd_history_up +=1
			$LineEdit.set_text(cmd_history[cmd_history_up])
	
	if is_tab_pressed:
		is_tab_pressed = Input.is_key_pressed(KEY_TAB)
	if $LineEdit.get_text() != "" and $LineEdit.has_focus() and Input.is_key_pressed(KEY_TAB) and not is_tab_pressed:
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
	print(idx, " ",prev_entered_latters," ", entered_latters," ", prev_com, " ", last_match)
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
		$LineEdit.text = prev_com + " "
		text_changed_by_player = true
		$LineEdit.set_cursor_position(prev_com.length()+1)
	prev_entered_latters = entered_latters

# This function is called from scripts/console_commands.gd to avoid the
# "Cannot access self without instance." error
func quit():
	get_tree().quit()

func set_console_opened(opened):
	# Close the console
	if opened == true:
		$AnimationPlayer.play("fade")
		# Signal handles the hiding at the end of the animation
	# Open the console
	elif opened == false:
		$AnimationPlayer.play_backwards("fade")
		show()
		$LineEdit.grab_focus()
		$LineEdit.clear()

# This signal handles the hiding of the console at the end of the fade-out animation
func _on_AnimationPlayer_finished():
	if is_console_opened():
		hide()

# Is the console fully opened?
func is_console_opened():
	if $AnimationPlayer.get_current_animation()!="":
		if $AnimationPlayer.get_current_animation_position() == $AnimationPlayer.get_current_animation_length():
			return 1
		elif $AnimationPlayer.get_current_animation_position() == 0:
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
		$LineEdit.clear()

# Registers a new command
func register_command(name, args):
	if args.has("target") and args.target != null and args.has("description") and args.has("args") and args.has("num_args"):
		if args.target.has_method(name):
			commands[name] = args
		else:
			print("Failed adding command ", name, ". The target has no this function!")
	else:
		print("Failed adding command ", name, ". Invalid arguments!")

# Registers a new cvar (control variable)
func register_cvar(name, args):
	if args.has("target") and args.target != null and args.has("description") and args.has("type") and args.has("default_value"):
		if args.type != TYPE_STRING and args.type != TYPE_BOOL:
			if not args.has("min_value") and not args.has("max_value"):
				print("Failed adding command ", name, ". The numeric parameter should have min_value and max_value arguments")
				return

		if args.target.has_method(name):
			cvars[name] = args
			cvars[name].value = cvars[name].default_value
		else:
			print("Failed adding command ", name, ". The target has no this function!")
	else:
		print("Failed adding command ", name, ". Invalid arguments!")

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
	var description = command.description
	var args = command.args
	var num_args = command.num_args
	if num_args >= 1:
		append_bbcode("[color=#ffff66]" + cmd + ":[/color] " + description + " [color=#88ffff](usage: " + cmd + " " + args + ")[/color]\n")
	else:
		append_bbcode("[color=#ffff66]" + cmd + ":[/color] " + description + " [color=#88ffff](usage: " + cmd + ")[/color]\n")

# Describes a cvar, used by the "cvarlist" command and when the user enters a cvar name without any arguments
func describe_cvar(cvar):
	var cvariable = cvars[cvar]
	var description = cvariable.description
	var type = cvariable.type
	var default_value = cvariable.default_value
	var value = cvariable.value
	if type == TYPE_STRING or type == TYPE_BOOL:
		append_bbcode("[color=#88ff88]" + str(cvar) + ":[/color] [color=#9999ff]\"" + str(value) + "\"[/color]  " + str(description) + " [color=#ff88ff](default: \"" + str(default_value) + "\")[/color]\n")
	else:
		var min_value = cvariable.min_value
		var max_value = cvariable.max_value
		append_bbcode("[color=#88ff88]" + str(cvar) + ":[/color] [color=#9999ff]" + str(value) + "[/color]  " + str(description) + " [color=#ff88ff](" + str(min_value) + ".." + str(max_value) + ", default: " + str(default_value) + ")[/color]\n")

func handle_command(text):
	# The current console text, splitted by spaces (for arguments)
	var cmd = text.split(" ", false)
	# Check if the first word is a valid command
	if commands.has(cmd[0]):
		var command = commands[cmd[0]]
		print("> " + text)
		append_bbcode("[b]> " + text + "[/b]\n")
		# Check target script argument
		# If no argument is supplied, then show command description and usage, but only if command has at least 1 argument required
		if cmd.size() == 1 and not command.num_args == 0:
			describe_command(cmd[0])
		else:
			# Run the command! If there are no arguments, don't pass any to the other script.
			if command.num_args == 0:
				command.target.call(cmd[0])
			else:
				command.target.callv(cmd[0], [cmd[1]])
	# Check if the first word is a valid cvar
	elif cvars.has(cmd[0]):
		var cvar = cvars[cmd[0]]
		print("> " + text)
		append_bbcode("[b]> " + text + "[/b]\n")
		# Check target script argument
		# If no argument is supplied, then show cvar description and usage
		if cmd.size() == 1:
			describe_cvar(cmd[0])
		else:
			# Let the cvar change values!
			if cvar.type == TYPE_STRING:
				for word in range(1, cmd.size()):
					if word == 1:
						cvar.value = str(cmd[word])
					else:
						cvar.value += str(" " + cmd[word])
			elif cvar.type == TYPE_INT:
				cvar.value = clamp(int(cmd[1]),int(cvar.min_value),int(cvar.max_value))
			elif cvar.type == TYPE_REAL:
				cvar.value = clamp(float(cmd[1]),float(cvar.min_value),float(cvar.max_value))
			elif cvar.type == TYPE_BOOL:
				print(cmd[1])
				if cmd[1].to_lower() == "true" or int(cmd[1])>0:
					cvar.value = true
				else:
					cvar.value = false

			# Call setter code
			cvar.target.callv(cmd[0], [cvar.value])
	else:
		# Treat unknown commands as unknown
		append_bbcode("[b]> " + text + "[/b]\n")
		append_bbcode("[i][color=#ff8888]Unknown command or cvar: " + cmd[0] + "[/color][/i]\n")
	$LineEdit.clear()

#######################################################################
##################_____STANDART_COMMMAND_LIST_____#####################
#######################################################################
func echo(text):
	# Erase "echo" from the output
	#text.erase(0, 5)
	Console.append_bbcode("\n" + text + "\n")

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

func client_max_fps(value):
	Engine.set_target_fps(int(value))