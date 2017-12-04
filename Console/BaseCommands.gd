
extends Object


var client_max_fps = 61 setget set_client_max_fps, get_client_max_fps


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
    description = "clear the terminal",
    args = [],
    target = Console
  })

  Console.register_command("version", {
    description = "clear the terminal",
    args = [['show_full', TYPE_BOOL]],
    target = Console
  })

  # Register built-in cvars
  Console.register_cvar("client_max_fps", {
    description = "The maximal framerate at which the application can run",
    type = TYPE_INT,
    min_value = 10,
    max_value = 1000,
    target = self
  })


func set_client_max_fps(value):
  client_max_fps = value

func get_client_max_fps():
  return client_max_fps
