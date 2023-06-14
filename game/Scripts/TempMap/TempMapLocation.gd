extends Area2D


const margin = 16

@export var sprite: Sprite2D = null

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var location_data: TempMapLocationData = null

var parent_locations: Array[Vector2] = []

var distance_from_top: float = 0


func _on_mouse_entered():
	animation_player.play('hover_animation')


func _on_mouse_exited():
	animation_player.play_backwards('hover_animation')
	
	
func _angle_between(from: Vector2, to: Vector2) -> float:
	var x: float = from.x
	var y: float = from.y

	var delta_x: float = to.x - x
	var delta_y: float = to.y - y

	var rotation: float = -atan2(delta_x, delta_y)
	rotation = deg_to_rad(rad_to_deg(rotation) + 180)

	return rotation


func _get_point_on_circle(center: Vector2, radians: float, radius: float) -> Vector2:
	var x: float = center.x
	var y: float = center.y

	radians -= deg_to_rad(90.0)
	var x_pos_y: float = round((x + cos(radians) * radius));
	var y_pos_y: float = round((y + sin(radians) * radius));

	return Vector2(x_pos_y, y_pos_y);
