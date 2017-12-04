
extends 'BaseType.gd'


var rmin
var rmax


func _init(_min, _max):
  name = 'Range'
  t = null
  rmin = _min
  rmax = _max


# @param  Varian  _value
func check(_value):  # bool
  var r = RegEx.new()
  r.compile('^\\w+$')

  rematch = r.search(_value)

  if rematch:
    return true

  return false


func get():  # string
  if rematch and rematch is RegExMatch:
    return 213
