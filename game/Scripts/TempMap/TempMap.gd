extends Control


@onready var root_location_data: TempMapLocationData = Globals.map_provider.get_map()
var root_location: Area2D = null

var map_location_scene = preload("res://Scenes/Map/BattleLocation.tscn")

# coordinates: Vector2i -> location: Area2D
var location_map: Dictionary = {}

var active_location = null


func _ready():
	var visit_queue: Array[TempMapLocationData] = []

	for root_child_data in root_location_data.children:
		visit_queue.push_back(root_child_data)

	root_location = map_location_scene.instantiate()
	root_location.location_data = root_location_data
	root_location.position = Vector2(
		root_location.sprite.texture.get_width(),
		self.size.y / 2 - root_location.sprite.texture.get_height() / 2
	)
	set_location_distance_from_top(root_location)
	root_location.location_data.is_player_location = true

	add_child(root_location)
	location_map[root_location_data.coordinates] = root_location
	
	while (not visit_queue.is_empty()):
		var current_location_data: TempMapLocationData = visit_queue.pop_front()

		for child_data in current_location_data.children:
			if not location_map.has(child_data.coordinates):
				visit_queue.push_back(child_data)

		var current_location = map_location_scene.instantiate()
		current_location.location_data = current_location_data
		set_location_distance_from_top(current_location)
		
		for parent_data in current_location_data.parents:
			current_location.parent_locations.append(location_map[parent_data.coordinates].position)
		
		var parent_position = (func():
			var x: int = 0
			var y_sum: int = 0
			for parent_data in current_location_data.parents:
				var parent = location_map[parent_data.coordinates]
				y_sum += parent.position.y
				x = parent.position.x

			return Vector2(x, y_sum / current_location_data.parents.size())).call()

		if (current_location_data.parents.size() == 1 and current_location_data.parents.front().children.size() == 2): 
			if (current_location_data == current_location_data.parents.front().children.front()):
				current_location.position = parent_position + Vector2(current_location.sprite.texture.get_width() * 1.5, -1 * current_location.distance_from_top)
			else:
				current_location.position = parent_position + Vector2(current_location.sprite.texture.get_width() * 1.5, 1 * current_location.distance_from_top)
		else:
			if current_location_data.is_boss_location or current_location_data.is_miniboss_location:
				current_location.position = Vector2(parent_position.x + current_location.sprite.texture.get_width() * 1.5, root_location.position.y)
			else:
				current_location.position = parent_position + Vector2(current_location.sprite.texture.get_width() * 1.5, 0)

		add_child(current_location)
		location_map[current_location_data.coordinates] = current_location
	
	# draw lines
	for location in location_map.values():
		for parent_location in location.parent_locations:
			var line := Line2D.new()
			line.add_point(location.position)
			line.add_point(parent_location)
			line.default_color = Color.GRAY
			line.width = 4
			line.antialiased = true
			add_child(line)
			move_child(line, 1)

	$MapOpen.play()


func set_location_distance_from_top(location: Node2D):
	var location_data: TempMapLocationData = location.location_data

	if location_data.is_boss_location or location_data.is_miniboss_location or location_data.parents.size() == 0:
		location.distance_from_top = root_location.position.y
		return
	
	var parents: Array[TempMapLocationData] = location_data.parents
	if parents.size() == 1:
		var parent = parents.front()
		if parent.children.size() == 1:
			location.distance_from_top = location_map[parent.coordinates].distance_from_top
		else:
			location.distance_from_top = location_map[parent.coordinates].distance_from_top / 2
	else:
		location.distance_from_top = location_map[parents[0].coordinates].distance_from_top + location_map[parents[1].coordinates].distance_from_top
