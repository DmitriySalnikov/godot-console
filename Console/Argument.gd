
extends 'IArgument.gd'
const Types = preload('Types/Types.gd')


# @param  string  _name
# @param  int|Type  type
# @param  Type.t  _default
func _init(_name, _type, _default = null):
	name = _name

	if typeof(_type) == TYPE_OBJECT:
		type = _type
	else:
		type = Types.createT(_type)

	default = _default


# @param  Variant  _value
func set_value(_value):  # int
	var set_check = type.check(_value)
	if set_check == OK:
		value = type.get()
		return OK

	return set_check


# Should be ?static? or should be placed in another class...
# @param  Array<Argument>  args
static func to_string(args):  # string
	var result = ''

	var argsSize = args.size()
	for i in range(argsSize):
		result += args[i].name + ':' + args[i].type.name

		if i != argsSize - 1:
			result += ' '

	return result
