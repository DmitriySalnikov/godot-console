
extends 'BaseType.gd'


func _init():
	name = 'String'
	t = TYPE_STRING


func get():  # string
	if rematch and rematch is RegExMatch:
		return str(rematch.get_string())

	return ""
