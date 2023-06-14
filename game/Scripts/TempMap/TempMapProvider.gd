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
	root.is_player_location = true
	var visit_queue: Array[TempMapLocationData] = [root]

	var position_map: TempPositionMap = TempPositionMap.new()
	position_map.position_map = {root.coordinates: root}

	var is_miniboss_generated: bool = false
	var is_boss_generated: bool = false

	while (not visit_queue.is_empty()):
		var current_location: TempMapLocationData = visit_queue.pop_front()
		# + 1 for counting from 1, + 1 for child position
		var length = current_location.coordinates.y + 2

		var is_generation_finished = current_location.is_boss_location
		if (is_generation_finished):
			break

		if (length == miniboss_location):
			if (is_miniboss_generated):
				continue

			var miniboss_parents: Array[TempMapLocationData] = []
			var current_position := Vector2i(0, current_location.coordinates.y)
			while (position_map.position_map.has(current_position)):
				miniboss_parents.append(position_map.position_map[current_position])
				current_position.x += 1

			var miniboss_position = position_map.find_child_position(current_location.coordinates.y)
			var miniboss := TempMapLocationData.new(miniboss_parents, miniboss_position, 0, true)
			visit_queue.push_back(position_map.add(miniboss))

			is_miniboss_generated = true
		elif (length == map_length):
			if (is_boss_generated):
				continue

			var boss_parents: Array[TempMapLocationData] = []
			var current_position := Vector2i(0, current_location.coordinates.y)
			while (position_map.position_map.has(current_position)):
				boss_parents.append(position_map.position_map[current_position])
				current_position.x += 1

			var boss_position = position_map.find_child_position(current_location.coordinates.y)
			var boss := TempMapLocationData.new(boss_parents, boss_position, 0, false, true)
			visit_queue.push_back(position_map.add(boss))

			is_boss_generated = true
		else:
			var should_deepen: bool = current_location.deepness_level < Globals.map_max_deepness_level and randf() < Globals.map_deepen_chance
			var should_shallow: bool = current_location.deepness_level > 0 and randf() < Globals.map_shallow_chance
			if (should_deepen):
					for deepened_child in position_map.add_deepened_children(current_location):
						visit_queue.push_back(deepened_child)
			elif (should_shallow and can_shallow(position_map, current_location)):
				visit_queue.push_back(position_map.add_shallowed_child(current_location))
			else:
				if current_location.has_shallowed():
					continue

				var child_position: Vector2i = position_map.find_child_position(
					current_location.coordinates.y)
				var child := TempMapLocationData.new(
					[current_location], child_position, current_location.deepness_level
				)
				visit_queue.push_back(position_map.add(child))

	return root


func can_shallow(position_map: TempPositionMap, location: TempMapLocationData) -> bool:
	var potential_other_shallowers: Array[TempMapLocationData] = []

	if (location.coordinates.x > 0):
		var previous_sibling: TempMapLocationData = position_map.position_map[Vector2i(location.coordinates.x - 1, location.coordinates.y)]
		if not location.shallowed_with.has(previous_sibling.coordinates) and previous_sibling.has_not_sired_unshallowed_children():
			potential_other_shallowers.push_back(previous_sibling)

	var next_sibling_position: Vector2i = Vector2i(location.coordinates.x + 1, location.coordinates.y)
	var next_sibling: TempMapLocationData = position_map.position_map.get(next_sibling_position)
	if (next_sibling != null and not location.shallowed_with.has(next_sibling_position) and next_sibling.has_not_sired_unshallowed_children()):
		potential_other_shallowers.push_back(next_sibling)

	return not potential_other_shallowers.is_empty()
