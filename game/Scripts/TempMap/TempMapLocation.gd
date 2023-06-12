extends Area2D


@export var sprite: Sprite2D = null

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var location_data: TempMapLocationData = null


func _on_mouse_entered():
	animation_player.play('hover_animation')


func _on_mouse_exited():
	animation_player.play_backwards('hover_animation')
