
extends 'BaseType.gd'


func _init():
	name = 'Float'
	t = TYPE_REAL


# @param  Varian  _value
func check(_value):  # bool
	rematch = Console.RegExLib.Float.search(_value)

	if rematch and rematch is RegExMatch:
		return OK

	return FAILED


func get():  # float
	if rematch and rematch is RegExMatch:
		return float(rematch.get_string())

	return 0
