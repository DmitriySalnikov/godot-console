
extends 'IBaseType.gd'


# @param  Varian  _value
func check(_value):  # int
	rematch = Console.RegExLib.get(t)

	if rematch and rematch is RegEx:
		rematch = rematch.search(_value)

		if rematch and rematch is RegExMatch:
			return OK

	return FAILED
