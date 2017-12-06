
extends 'IArgument.gd'
const Types = preload('Types/Types.gd')


# @param  string|null  _name
# @param  int|BaseType  _type
func _init(_name, _type = 0):
	name = _name

	if typeof(_type) == TYPE_OBJECT:
		type = _type
	else:
		type = Types.createT(_type)


# @param  Variant  _value
func set_value(_value):  # int
	var set_check = type.check(_value)

	if set_check == OK:
		value = type.get()

	return set_check


# @param  Array<Argument>  args
static func to_string(args):  # string
	var result = ''

	var argsSize = args.size()
	for i in range(argsSize):
		if args[i].name:
			result += args[i].name + ':'

		result += args[i].type.name

		if i != argsSize - 1:
			result += ' '

	return result
