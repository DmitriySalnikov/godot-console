
extends 'BaseType.gd'
const IArgument = preload('res://Console/IArgument.gd')


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
func check(_value):  # int
	if allowedItems.has(_value):
		value = _value
		return OK

	return IArgument.ARGASSIG.CANCELED


func get():  # Variant
	return value
