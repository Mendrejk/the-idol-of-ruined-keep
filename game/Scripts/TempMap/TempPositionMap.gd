extends Resource

class_name TempPositionMap


var position_map: Dictionary = {}


func add_child(
	parent: TempMapLocationGenerationData,
	child: TempMapLocationData
	) -> TempMapLocationGenerationData:
	var child_position: Vector2i = find_child_position(parent.generation_position.y)

	var generation_child := TempMapLocationGenerationData.new(child, child_position)

	position_map[child_position] = generation_child

	return generation_child


func add_shallowed_child(parent: TempMapLocationGenerationData) -> TempMapLocationGenerationData:
	var potential_other_shallowers: Array[TempMapLocationGenerationData] = []

	if (parent.generation_position.x > 0):
		potential_other_shallowers.push_back(position_map[Vector2i(parent.generation_position.x - 1, parent.generation_position.y)])

	var next_sibling_position: Vector2i = Vector2i(parent.generation_position.x + 1, parent.generation_position.y)
	var next_sibling: TempMapLocationGenerationData = position_map.get(next_sibling_position)
	if (next_sibling != null):
		potential_other_shallowers.push_back(next_sibling)
	
	var other_shallower: TempMapLocationGenerationData = potential_other_shallowers[randi() % potential_other_shallowers.size()]
	var shallowers: Array[TempMapLocationGenerationData] = [parent, other_shallower]

	var child_deepness_level: int = (func():
		if (parent.location.deepness_level == other_shallower.location.deepness_level):
			return parent.location.deepness_level - 1
		elif (parent.location.deepness_level < other_shallower.location.deepness_level):
			return parent.location.deepness_level

		return other_shallower.location.deepness_level).call()

	var shallowers_data: Array[TempMapLocationData] = []
	for shallower in shallowers:
		shallowers_data.append(shallower.location)

	var child := TempMapLocationData.new(shallowers_data, child_deepness_level)
	var child_position: Vector2i = find_child_position(parent.generation_position.y)
	
	var generation_child := TempMapLocationGenerationData.new(child, child_position)
	
	return generation_child


func find_child_position(parent_y: int) -> Vector2i:
	var child_position: Vector2i = Vector2i(0, parent_y + 1)
	while (position_map.has(child_position)):
		child_position.x += 1
		
	return child_position
