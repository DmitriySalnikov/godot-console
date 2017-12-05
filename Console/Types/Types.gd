
extends Object


const TYPES = {
	'0': preload('Any.gd'),
	'1': preload('Bool.gd'),
	'2': preload('Int.gd'),
	'3': preload('Float.gd'),
	'4': preload('String.gd'),
}


# @param  int  _type
static func createT(_type):
	var str_type = str(_type)

	if (TYPES.has(str_type)):
		return TYPES[str_type].new()
