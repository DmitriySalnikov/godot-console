
extends Object


var BASE_TYPES = {
  '1': 'Bool',
  '2': 'Int',
  '3': 'Float',
  '4': 'String'
}


# @var  string
var name setget _set_protected
# @var  int
var t setget _set_protected


# @param  int  _type
func _init(_type):
  if BASE_TYPES.has(str(_type)):
    name = BASE_TYPES[str(_type)]
  t = _type


func _set_protected(value):
  pass
