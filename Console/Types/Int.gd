
extends 'Type.gd'


# @param  int  _type
func _init():
  ._init(TYPE_INT)

  name = 'Int'


func check(value):
  var r = RegEx.new()
  r.compile('\\d+')
