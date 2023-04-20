extends Node2D

const plane_len = 30
const path_count = 9
const node_count = plane_len * plane_len / path_count

const map_scale = 25.0

var map_locations = {}
var map_location_scene = preload("res://Scenes/MapLocation.tscn")

var active_location = null

func _ready():
	var generator = preload("res://Scripts/Map/MapGenerator.gd").new()
	var map_data = generator.generate(plane_len, node_count, path_count)
	
	for k in map_data.nodes.keys():
		var point = map_data.nodes[k]
		var map_location = map_location_scene.instantiate()
		map_location.position = point * map_scale + Vector2(50, 0)

		add_child(map_location)
		map_locations[k] = map_location
	
	for path in map_data.paths:
		for i in range(path.size() - 1):
			var index1 = path[i]
			var index2 = path[i + 1]
			
			map_locations[index1].add_child_map_location(map_locations[index2])

	mark_start_and_end()

func mark_start_and_end():
	var left_most_location = map_locations[0]
	var right_most_location = map_locations[0]
	
	for map_location in map_locations.values():
		if map_location.global_position.x < left_most_location.global_position.x:
			left_most_location = map_location

		if map_location.global_position.x > right_most_location.global_position.x:
			right_most_location = map_location
	
	left_most_location.is_active = true
	right_most_location.is_last = true
	
	active_location = left_most_location

#func find_hovered_location
