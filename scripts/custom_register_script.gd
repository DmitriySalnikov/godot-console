extends Node


func _ready():
	
	# Register custom cvar
	Console.register_cvar("label_text", {
		description = "The text of example label",
		type = TYPE_STRING,
		default_value = "",
		target = self
	})
	
	# Register custom cvar
	Console.register_cvar("pb_value", {
		description = "The value of progress bar",
		type = TYPE_INT,
		default_value = 0,
		min_value = 0,
		max_value = 100,
		target = self
	})
	
	# Register custom cvar
	Console.register_cvar("cb_checked", {
		description = "The value of chack box",
		type = TYPE_BOOL,
		default_value = false,
		target = self
	})
	
	Console.register_command("play_anim", {
		description = "Start playing animation on test scene with specific speed",
		args = "speed",
		num_args = 1,
		target = self
	})

func label_text(text):
	$ExampleLabel.text = text

func pb_value(val):
	$ProgressBar.value = int(val)

func play_anim(speed):
	$AnimationPlayer.play("test")
	$AnimationPlayer.set_speed_scale(float(speed))

func cb_checked(val):
	$CheckBox.pressed = val