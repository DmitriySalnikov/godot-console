
extends 'BaseType.gd'


func _init():
	name = 'String'
	t = TYPE_STRING


# @param  Varian  _value
func check(_value):	# bool
	var r = RegEx.new()
	r.compile('^\\w+$')

	rematch = r.search(_value)

	if rematch and rematch is RegExMatch:
		return true

	return false


func get():	# string
	if rematch and rematch is RegExMatch:
		return str(rematch.get_string())

	return ""
