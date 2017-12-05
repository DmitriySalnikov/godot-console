
extends 'BaseType.gd'


# @var  Variant
var value


func _init():
	name = 'Any'
	t = null


# @param  Varian  _value
func check(_value):  # int
	value = _value
	return OK


func get():  # Variant
	return value
