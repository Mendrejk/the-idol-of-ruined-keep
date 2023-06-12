extends Resource

class_name TempMapProvider


var map: TempMapLocationData = null : get = get_map


func get_map() -> TempMapLocationData:
	if not map:
		map = generate_map()

	return map


func generate_map() -> TempMapLocationData:
	var map_length: int = randi_range(Globals.map_min_length, Globals.map_max_length)
	var miniboss_location: int = int(map_length * Globals.map_miniboss_length_ratio)
	
	var root: TempMapLocationData = TempMapLocationData.new()
	var visit_queue: Array[TempMapLocationGenerationData] = [TempMapLocationGenerationData.new(root, Vector2i(0, 0))]

	var position_map: TempPositionMap = TempPositionMap.new()
	position_map.position_map = {Vector2i(0,0): root}
	
	var is_miniboss_generated: bool = false
	var is_boss_generated: bool = false

	while (not visit_queue.is_empty()):
		var current_location: TempMapLocationGenerationData = visit_queue.pop_front()
		# + 1 for counting from 1, + 1 for child position
		var length = current_location.generation_position.y + 2

		var is_generation_finished = current_location.location.is_boss_location
		if (is_generation_finished):
			break

		if (length == miniboss_location):
			if (is_miniboss_generated):
				pass

			var miniboss_parents: Array[TempMapLocationData] = []
			var current_position := Vector2i(0, current_location.generation_position.y)
			while (position_map.position_map.has(current_position)):
				miniboss_parents.append(position_map.position_map[current_position])
				current_position.x += 1

			var miniboss := TempMapLocationData.new(miniboss_parents, 0, true)
			visit_queue.push_back(position_map.add_child(current_location, miniboss))

			is_miniboss_generated = true
		elif (length == map_length):
			if (is_boss_generated):
				pass

			var boss_parents: Array[TempMapLocationData] = []
			var current_position := Vector2i(0, current_location.generation_position.y)
			while (position_map.position_map.has(current_position)):
				boss_parents.append(position_map.position_map[current_position])
				current_position.x += 1

			var boss := TempMapLocationData.new(boss_parents, 0, false, true)
			visit_queue.push_back(position_map.add_child(current_location, boss))

			is_boss_generated = true
			pass
		else:
			var should_deepen: bool = current_location.location.deepness_level < Globals.map_max_deepness_level and randf() < Globals.map_deepen_chance
			var should_shallow: bool = current_location.location.deepness_level > 0 and randf() < Globals.map_shallow_chance
			if (should_deepen):
					for deepened_child in current_location.location.add_deepened_children():
						visit_queue.push_back(position_map.add_child(current_location, deepened_child))
			elif (should_shallow and can_shallow(position_map, current_location)):
				visit_queue.push_back(position_map.add_shallowed_child(current_location))
			else:
				visit_queue.push_back(
					position_map.add_child(
						current_location,
						TempMapLocationData.new([current_location.location], current_location.location.deepness_level)
					)
				)

	return root


func can_shallow(position_map: TempPositionMap, location: TempMapLocationGenerationData) -> bool:
	var siblings: Array[TempMapLocationGenerationData] = []
	var current_location := Vector2i(0, location.generation_position.y)

	while (position_map.position_map.has(current_location)):
		if (current_location != location.generation_position):
			siblings.append(position_map.position_map[current_location])
		current_location.x += 1

	return !siblings.is_empty()
