
extends Node
const Range = preload('res://Console/Types/Range.gd')


var label_text setget set_label_text, get_label_text
var pb_value setget set_pb_value, get_pb_value
var cb_checked setget set_cb_checked, get_cb_checked


func _ready():

	# Register custom cvar
	Console.register_cvar("label_text", {
		description = "The text of example label",
		arg = ['text', TYPE_STRING],
		target = self
	})

	Console.register_command("change_label_text", {
		description = "Set the text of example label if condition is true",
		args = [['condition', TYPE_BOOL], ['text', TYPE_STRING]],
		target = self
	})

	# Register custom cvar
	Console.register_cvar("pb_value", {
		description = "The level of progress bar",
		arg = ['value', Range.new(0, 100)],
		target = self
	})

	# Register custom cvar
	Console.register_cvar("cb_checked", {
		description = "The value of check box",
		arg = ['checked', TYPE_BOOL],
		target = self
	})

	Console.register_command("play_anim", {
		description = "Start playing animation on test scene with specific speed",
		args = [["speed", TYPE_INT]],
		target = self
	})

func set_label_text(text):
	$ExampleLabel.text = text

func get_label_text():
	return $ExampleLabel.text


func change_label_text(cond, text):
	if cond:
		$ExampleLabel.text = text


func set_pb_value(val):
	$ProgressBar.value = int(val)

func get_pb_value():
	return $ProgressBar.value


func play_anim(speed):
	$AnimationPlayer.play("test")
	$AnimationPlayer.set_speed_scale(float(speed))


func set_cb_checked(val):
	$CheckBox.pressed = val

func get_cb_checked():
	return $CheckBox.pressed
