
extends 'BaseType.gd'


func _init():
	name = 'Int'
	t = TYPE_INT


# @param  Varian  _value
func check(_value):  # bool
	rematch = Console.RegExLib.Int.search(_value)

	if rematch and rematch is RegExMatch:
		return OK

	return FAILED


func get():  # int
	if rematch and rematch is RegExMatch:
		return int(rematch.get_string())

	return 0
