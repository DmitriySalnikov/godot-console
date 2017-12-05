
extends 'BaseType.gd'


# @var  int|float
var rmin
# @var  int|float
var rmax


# @param  int|float  _min
# @param  int|float  _max
func _init(_min, _max):
	name = 'Int'
	t = TYPE_INT
	rmin = _min
	rmax = _max


func get():  # string
	if rematch and rematch is RegExMatch:
		return clamp(int(rematch.get_string()), rmin, rmax)

	return 0
