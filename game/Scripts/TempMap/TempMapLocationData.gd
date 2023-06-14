extends Resource

class_name TempMapLocationData

var parents: Array[TempMapLocationData]
var children: Array[TempMapLocationData] = []

var coordinates: Vector2i

var is_player_location: bool = false
var is_miniboss_location: bool
var is_boss_location: bool

var deepness_level: int

var shallowed_with: Array[Vector2i] = []


func _init(_parents: Array[TempMapLocationData] = [], _coordinates: Vector2i = Vector2i(0, 0),
			_deepness_level: int = 0, _is_miniboss_location: bool = false,
			_is_boss_location: bool = false):
	parents = _parents
	coordinates = _coordinates

	deepness_level = _deepness_level
	is_miniboss_location = _is_miniboss_location
	is_boss_location = _is_boss_location
	
	for parent in _parents:
		parent.add_child(self)


func add_child(child: TempMapLocationData) -> TempMapLocationData:
	children.append(child)
	return child


func has_shallowed() -> bool:
	return not shallowed_with.is_empty()


func has_not_sired_unshallowed_children() -> bool:
	return not (not has_shallowed() and not children.is_empty())
