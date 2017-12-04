
extends 'BaseType.gd'


func _init():
	name = 'Bool'
	t = TYPE_BOOL


# @param  Varian  _value
func check(_value):  # bool
	var r = RegEx.new()
	r.compile('^(1|0|true|false)$')

	rematch = r.search(_value)

	if rematch and rematch is RegExMatch:
		return true

	return false


func get():  # bool
	if rematch and rematch is RegExMatch:
		var tmp = rematch.get_strings()[0]

		return false if tmp == '0' or tmp == 'false' else true

	return false
