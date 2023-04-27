extends Area2D

const margin = 12

var parent = null
var children: Array = []

var is_active: bool = false
var is_last: bool = false
var is_hovered: bool = false

func add_child_map_location(child):
	if !children.has(child):
		children.append(child)
		child.parent = self
		queue_redraw()

func _draw():
	draw_circle(Vector2.ZERO, 8, determine_colour())
	
	for child in children:
		var line = child.position - position
		var normal = line.normalized()
		line -= margin * normal
		var color = Color.GRAY
		draw_line(normal * margin, line, color, 2, true)

func determine_colour():
	if is_hovered:
		return Color.DARK_BLUE
	if is_active:
		return Color.GREEN_YELLOW
	if is_last:
		return Color.DARK_RED
	
	return Color.WHITE_SMOKE

func _on_mouse_entered():
	if not is_hovered and parent and parent.is_active:
		is_hovered = true
		queue_redraw()

func _on_mouse_exited():
	if is_hovered:
		is_hovered = false
		queue_redraw()


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().change_scene_to_file("res://Scenes/Playspace.tscn")
