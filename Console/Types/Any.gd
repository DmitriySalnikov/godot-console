
extends 'BaseType.gd'


# @var  Variant
var _value


func _init():
	name = 'Any'
	t = null


# @param  Varian  _value
func check(value):  # int
	_value = value
	return OK


func get():  # Variant
	return _value
