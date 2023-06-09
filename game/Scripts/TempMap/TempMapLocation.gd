extends Area2D


const margin = 16

@export var sprite: Sprite2D = null

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var location_data: TempMapLocationData = null

var parent_locations: Array[Vector2] = []

var distance_from_top: float = 0


func _ready():
	if location_data.is_boss_location:
		$BattleLocation.texture = load("res://Assets/Map/boss_node.png")
	elif location_data.is_miniboss_location:
		$BattleLocation.texture = load("res://Assets/Map/miniboss_node.png")

	if location_data.is_player_location:
		scale = Vector2(1.5, 1.5)


func _is_any_parent_player_location() -> bool:
	for parent in location_data.parents:
		if parent.is_player_location:
			return true

	return false


func _on_mouse_entered():
	if _is_any_parent_player_location():
		animation_player.play('hover_animation')


func _on_mouse_exited():
	if _is_any_parent_player_location():
		animation_player.play_backwards('hover_animation')


func _on_input_event(viewport, event, shape_idx):
	var is_event_left_click: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed

	if is_event_left_click and _is_any_parent_player_location():
		for parent in location_data.parents:
			parent.is_player_location = false
		location_data.is_player_location = true

		Globals.level_number = location_data.coordinates.y
		print(Globals.level_number)
		if (Globals.level_number == (Globals.map_length-1)) or (Globals.level_number == ((Globals.map_length*Globals.map_miniboss_length_ratio)-1)):
			get_tree().change_scene_to_file("res://Scenes/Dialogue.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/Playspace.tscn")
