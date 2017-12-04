
extends 'BaseType.gd'


# @var  int|float
var rmin
# @var  int|float
var rmax


# @param  int|float  _min
# @param  int|float  _max
func _init(_min, _max):
	name = 'Int'
	t = null
	rmin = _min
	rmax = _max


# @param  Varian  _value
func check(_value):  # bool
	var r = RegEx.new()
	r.compile('^\\d+$')

	rematch = r.search(_value)

	if rematch and rematch is RegExMatch:
		return OK

	return FAILED


func get():  # string
	if rematch and rematch is RegExMatch:
		return clamp(int(rematch.get_string()), rmin, rmax)

	return 0
