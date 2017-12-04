
extends 'BaseType.gd'
const Argument = preload('res://Console/IArgument.gd')


# @var  Array<Variant>
var allowedItems

# @var  Variant
var value


# @param  Array<Variant>  _allowedItems
func _init(_allowedItems):
	name = 'WhiteList'
	t = null
	allowedItems = _allowedItems


# @param  Variant  _value
func check(_value):  # bool
	if allowedItems.has(_value):
		value = _value
		return OK

	return Argument.ARGASSIG.CANCELED


func get():  # Variant
	return value
