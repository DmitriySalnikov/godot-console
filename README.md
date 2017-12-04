# Godot Console

A **work-in-progress** Quake-style console for Godot. Requires a Godot 3.0.

![Preview](https://lut.im/z7lquRdc5n/IRrUJuiJdUUuWfuO.png)

## Features

- Commands
- Cvars
- Scrolling
- Toggleable console with fade animation (use <kbd>Shift+Escape</kbd> or <kbd>~</kbd> to toggle, needs custom actions in the tab "Project Settings/Input Map": console_toggle, console_up, console_down)
- Easily extensible with new commands
- Rich text format (colors, bold, italic, and more) using a RichTextLabel
- Enhance tab completion

## Examples

For command:
```gdscript
register_command("command", { # Name of command
	description = "", # Description of command
	args = [['arg_name', ARG_TYPE], ...], # Arguments
	target = self # Target script to bind command
})
```
For cvar:
```gdscript
register_cvar("cvar", {
	description = "",
	type = TYPE_INT, # Type of value (TYPE_BOOL,TYPE_INT, TYPE_REAL, TYPE_STRING)
	default_value = 0,
	min_value = 10, # Only needed for TYPE_INT and TYPE_REAL
	max_value = 1000, # Only needed for TYPE_INT and TYPE_REAL
	target = self
})
```

## TODO

- Sanitize int/float cvar values (based on existing min/max value data)
- Navigating command history in the LineEdit

## License

Copyright (c) 2016 Hugo Locurcio and contributors

Licensed under the MIT license, see `LICENSE.md` for more information.
