Godot Console
============

A **work-in-progress** Quake-style console for Godot. Requires a Godot 3.0.

![Preview](https://lut.im/z7lquRdc5n/IRrUJuiJdUUuWfuO.png)

## Features

- Commands
- Variables
- Scrolling
- Toggleable console with fade animation (use <kbd>Shift+Escape</kbd> or <kbd>~</kbd> to toggle, needs custom actions in the tab 'Project Settings/Input Map': console_toggle, console_up, console_down)
- Easily extensible with new commands
- Rich text format (colors, bold, italic, and more) using a RichTextLabel
- Enhance tab completion

## Examples

Registering a command:
```gdscript
Console.register_command('method_name', {
	description = '',  # Description of command
	args = [['arg_name', ARG_TYPE], ...],  # Arguments
	target = self  # Target script to bind command to
})
```
Registering a variable:
```gdscript
Console.register_cvar('variable_name', {
	description = '',  # Description of command
	arg = ['arg_name', ARG_TYPE]  # Argument
	target = self  # Target script to bind command to
})
```

ARG_TYPE must be set to engine `TYPE_*` constant (right now supported types are: `TYPE_BOOL`, `TYPE_INT`, `TYPE_REAL` and `TYPE_STRING`) OR to instance of Console type class (`Console/Types/`)
You can find more examples in `scripts/custom_register_script.gd`

## TODO

- More types
- Code refactor
- Navigating command history in the LineEdit

## License

Copyright (c) 2016 Hugo Locurcio and contributors

Licensed under the MIT license, see `LICENSE.md` for more information.
