extends Control


@onready var root_location_data: TempMapLocationData = Globals.map_provider.get_map()

var map_locations = []
var map_location_scene = preload("res://Scenes/Map/BattleLocation.tscn")

var active_location = null


func _ready():
	var root_location = map_location_scene.instantiate()
	root_location.location_data = root_location_data
	root_location.position = Vector2(
		root_location.sprite.texture.get_width(),
		self.size.y / 2 - root_location.sprite.texture.get_height() / 2
	)
	add_child(root_location)
	#location_map[root_location_data] = root_location
	map_locations.append(root_location)

	for child in root_location_data.children:
		instantiate_locations(child)


func instantiate_locations(current_location_data: TempMapLocationData):
	var current_location = map_location_scene.instantiate()
	current_location.location_data = current_location_data

	var parent_position = (func():
		var x: int = 0
		var y_sum: int = 0
		for parent in current_location_data.parents:
			for location in map_locations:
				if location.location_data == parent:
					y_sum += location.position.y
					x = location.position.x
					break

		return Vector2(x, y_sum / current_location_data.parents.size())).call()

	if (current_location_data.parents.size() == 1 and current_location_data.parents.front().children.size() == 2):
		if (current_location_data == current_location_data.parents.front().children.front()):
			current_location.position = parent_position + Vector2(current_location.sprite.texture.get_width() * 1.5, -0.75 * current_location.sprite.texture.get_height())
		else:
			current_location.position = parent_position + Vector2(current_location.sprite.texture.get_width() * 1.5, 0.75 * current_location.sprite.texture.get_height())
	else:
		current_location.position = parent_position + Vector2(current_location.sprite.texture.get_width() * 1.5, 0)

	add_child(current_location)
	#location_map[current_location_data] = current_location
	map_locations.append(current_location)
	
	for child in current_location_data.children:
		instantiate_locations(child)
