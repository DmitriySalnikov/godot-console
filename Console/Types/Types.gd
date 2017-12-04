
extends Object
const BaseType = preload('IBaseType.gd')


const TYPES = {
  '1': preload('Bool.gd'),
  '2': preload('Int.gd'),
  '4': preload('String.gd'),
}


# @param  int  _type
func create(_type):
  if (TYPES.has(str(_type))):
    return TYPES[str(_type)].new()
