extends Object

var Bool  = RegEx.new()
var Float = RegEx.new()
var Int   = RegEx.new()
var Str   = RegEx.new()

func _init():
	Bool.compile('^(1|0|true|false)$')
	Float.compile('^[+-]?([0-9]*\\.?[0-9]+|[0-9]+\\.?[0-9]*)([eE][+-]?[0-9]+)?$')
	Int.compile('^\\d+$')
	Str.compile('^\\w+$')
	