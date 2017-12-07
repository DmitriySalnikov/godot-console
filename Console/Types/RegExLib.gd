
extends Object


const _patterns = {
	'1': '^(1|0|true|false)$',  # bool
	'2': '^\\d+$',  # int
	'3': '^[+-]?([0-9]*[\\.\\,]?[0-9]+|[0-9]+[\\.\\,]?[0-9]*)([eE][+-]?[0-9]+)?$',  # float
}

# @var  Array<RegEx>
var _compiled = {}


# @param  int  type
func get(type):  # RegEx|int
	var str_type = str(type)

	if !_compiled.has(str_type):
		var r = RegEx.new()
		r.compile(_patterns[str_type])

		if r and r is RegEx:
			_compiled[str_type] = r
		else:
			return FAILED

	return _compiled[str_type]
