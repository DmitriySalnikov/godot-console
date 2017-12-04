
extends 'BaseType.gd'


func _init():
	name = 'Int'
	t = TYPE_INT


# @param  Varian  _value
func check(_value):  # bool
	var r = RegEx.new()
	r.compile('^\\d+$')

	rematch = r.search(_value)

	if rematch and rematch is RegExMatch:
		return true

	return false


func get():  # int
	if rematch and rematch is RegExMatch:
		return int(rematch.get_string())

	return 0
