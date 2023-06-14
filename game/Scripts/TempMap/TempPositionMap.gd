extends Resource

class_name TempPositionMap


var position_map: Dictionary = {}


func add(location: TempMapLocationData) -> TempMapLocationData:
	position_map[location.coordinates] = location

	return location


func add_deepened_children(parent: TempMapLocationData) -> Array[TempMapLocationData]:
	var _children: Array[TempMapLocationData] = []
	for n in 2:
		var child_position = find_child_position(parent.coordinates.y)
		var child: TempMapLocationData = TempMapLocationData.new(
			[parent], child_position, parent.deepness_level + 1
		)
		_children.append(child)
		add(child)

	return _children


func add_shallowed_child(parent: TempMapLocationData) -> TempMapLocationData:
	var potential_other_shallowers: Array[TempMapLocationData] = []

	if (parent.coordinates.x > 0):
		var previous_sibling: TempMapLocationData = position_map[Vector2i(parent.coordinates.x - 1, parent.coordinates.y)]
		if not parent.shallowed_with.has(previous_sibling.coordinates) and previous_sibling.has_not_sired_unshallowed_children():
			potential_other_shallowers.push_back(previous_sibling)

	var next_sibling_position: Vector2i = Vector2i(parent.coordinates.x + 1, parent.coordinates.y)
	var next_sibling: TempMapLocationData = position_map.get(next_sibling_position)
	if (next_sibling != null and not parent.shallowed_with.has(next_sibling_position) and next_sibling.has_not_sired_unshallowed_children()):
		potential_other_shallowers.push_back(next_sibling)
	
	var other_shallower: TempMapLocationData = potential_other_shallowers[randi() % potential_other_shallowers.size()]
	var shallowers: Array[TempMapLocationData] = [parent, other_shallower]
	
	parent.shallowed_with.append(other_shallower.coordinates)
	other_shallower.shallowed_with.append(parent.coordinates)

	var child_deepness_level: int = (func():
		if (parent.deepness_level == other_shallower.deepness_level):
			return parent.deepness_level - 1
		elif (parent.deepness_level < other_shallower.deepness_level):
			return parent.deepness_level

		return other_shallower.deepness_level).call()

	var child_position: Vector2i = find_child_position(parent.coordinates.y)
	var child := TempMapLocationData.new(shallowers, child_position, child_deepness_level)
	add(child)

	return child


func find_child_position(parent_y: int) -> Vector2i:
	var child_position: Vector2i = Vector2i(0, parent_y + 1)
	while (position_map.has(child_position)):
		child_position.x += 1
		
	return child_position
