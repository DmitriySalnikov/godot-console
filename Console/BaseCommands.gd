extends Object

var client_max_fps = 61 setget set_client_max_fps

func _init():
	Console.register_command("echo", {
		description = "Prints a string in console",
		args = [['message', TYPE_STRING]],
		target = Console
	})

	Console.register_command("history", {
		description = "Print all previous cmd used during the session",
		args = [],
		target = Console
	})

	Console.register_command("cmdlist", {
		description = "Lists all available commands",
		args = [],
		target = Console
	})

	Console.register_command("cvarlist", {
		description = "Lists all available cvars",
		args = [],
		target = Console
	})

	Console.register_command("help", {
		description = "Outputs usage instructions",
		args = [],
		target = Console
	})

	Console.register_command("quit", {
		description = "Exits the application",
		args = [],
		target = Console
	})

	Console.register_command("clear", {
		description = "Clear the terminal",
		args = [],
		target = Console
	})

	Console.register_command("version", {
		description = "Shows engine vesion",
		args = [['show_full', TYPE_BOOL]],
		target = Console
	})

	# Register built-in cvars
	Console.register_cvar("client_max_fps", {
		description = "The maximal framerate at which the application can run",
		arg = Console.Range.new(10, 1000),
		target = self
	})


func set_client_max_fps(value):
	client_max_fps = value
	Engine.set_target_fps(int(value))
