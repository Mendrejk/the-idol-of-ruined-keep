extends Resource

class_name TempMapLocationData

var parents: Array[TempMapLocationData]
var children: Array[TempMapLocationData] = []

var is_player_location: bool = false
var is_next_location: bool = false
var is_miniboss_location: bool
var is_boss_location: bool

var deepness_level: int


func _init(_parents: Array[TempMapLocationData] = [], _deepness_level: int = 0,
			_is_miniboss_location: bool = false, _is_boss_location: bool = false):
	parents = _parents
	deepness_level = _deepness_level
	is_miniboss_location = _is_miniboss_location
	is_boss_location = _is_boss_location
	
	for parent in _parents:
		parent.add_child(self)


func add_deepened_children() -> Array[TempMapLocationData]:
	var _children: Array[TempMapLocationData] = []
	for n in 2:
		var child: TempMapLocationData = TempMapLocationData.new([self], deepness_level + 1)
		_children.append(child)

	return children


func add_child(child: TempMapLocationData) -> TempMapLocationData:
	children.append(child)
	return child
