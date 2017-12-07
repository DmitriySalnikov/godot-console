
extends Object


enum ARGASSIG {
  OK,
  FAILED,
  CANCELED
}


# @var  string
var name
# @var  Type
var type setget _set_protected
# @var  Variant
var value setget set_value
# @var  Type.t
var default


# @param  Variant  _value
func set_value(_value):  # int
  pass


func _set_protected(value):
	pass
