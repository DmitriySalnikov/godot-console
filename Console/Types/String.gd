
extends 'BaseType.gd'


func _init():
	name = 'String'
	t = TYPE_STRING


# @param  Varian  _value
func check(_value):  # bool
	rematch = Console.RegExLib.Str.search(_value)

	if rematch and rematch is RegExMatch:
		return OK

	return FAILED


func get():  # string
	if rematch and rematch is RegExMatch:
		return str(rematch.get_string())

	return ""
