
extends Object
const Type = preload('Types/Type.gd')


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

  # if _type is Type:
  #   type = _type
  # else:
  type = Type.new(_type)

  default = _default


# @param  Variant  _value
func set_value(_value):  # int
  if type.t == TYPE_STRING:
    value = _value
  elif type.t == TYPE_INT:
    value = _value.to_int()
  elif type.t == TYPE_REAL:
    value = _value.to_float()
  elif type.t == TYPE_BOOL:
    value = false if _value == '0' or _value.to_lower() == 'false' else true

  if value != null:
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
