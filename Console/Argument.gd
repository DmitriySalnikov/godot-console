
extends Object
const BaseType = preload('Types/BaseType.gd')
const Types = preload('Types/Types.gd')


# @var  string
var name
# @var  Type
var type setget _set_protected
# @var  Variant
var value = null setget set_value
# @var  Type.t
var default


# @param  string  _name
# @param  int|Type  type
# @param  Type.t  _default
func _init(_name, _type, _default = null):
  name = _name

  if typeof(_type) == TYPE_OBJECT:
    type = _type
  else:
    type = Types.create(_type)

  default = _default


# @param  Variant  _value
func set_value(_value):  # int
  if type.check(_value):
    value = type.get()
    return OK

  return FAILED


# Should be ?static? or should be placed in another class...
# @param  Array<Argument>  args
func to_string(args):  # string
  var result = ''

  var argsSize = args.size()
  for i in range(argsSize):
    result += args[i].name + ':' + args[i].type.name

    if i != argsSize - 1:
      result += ' '

  return result


func _set_protected(value):
  pass
