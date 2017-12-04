
extends 'BaseType.gd'


var _e


# @param	int	e	how many numbers after the point to keep
func _init(e = 2):
	name = 'Float'
	t = TYPE_REAL

	_e = e


# @param	Varian	_value
func check(_value):	# bool
	var r = RegEx.new()
	r.compile('^[+-]?([0-9]*\\.?[0-9]+|[0-9]+\\.?[0-9]*)([eE][+-]?[0-9]+)?$')

	rematch = r.search(_value)

	if rematch:
		return true

	return false


func get():	# float
	if rematch and rematch is RegExMatch:
		return float(rematch.get_string())

	return 0
