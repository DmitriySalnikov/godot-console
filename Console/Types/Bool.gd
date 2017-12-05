
extends 'BaseType.gd'


func _init():
	name = 'Bool'
	t = TYPE_BOOL


func get():  # bool
	if rematch and rematch is RegExMatch:
		var tmp = rematch.get_strings()[0]

		return false if tmp == '0' or tmp == 'false' else true

	return false
