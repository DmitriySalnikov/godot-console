
extends 'BaseType.gd'


func _init():
	name = 'Int'
	t = TYPE_INT


func get():  # int
	if rematch and rematch is RegExMatch:
		return int(rematch.get_string())

	return 0
