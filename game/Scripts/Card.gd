extends Resource

class_name Card

var path: String
var name: String
var value: int
var cost: int
var type: String
var display_name: String

func _init(_path: String, _name: String, _value: int, _cost: int, _type: String, _display_name: String):
	path = _path
	name = _name
	value = _value
	cost = _cost
	type = _type
	display_name = _display_name
