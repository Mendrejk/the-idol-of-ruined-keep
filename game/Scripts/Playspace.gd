extends Node2D

@onready var ViewportSize = Vector2(get_viewport().size)

var Hero = load("res://Scripts/Hero.gd").new()
var Enemy = load("res://Scripts/Enemy.gd").new()

func _ready():
	randomize()
	$Enemies/Enemy.visible = true
	$Enemies/Enemy.position = ViewportSize * 0.4 + Vector2(200,0)
	$Enemies/Enemy.scale *= 0.3
	$Characters/Hero.visible = true
	$Characters/Hero.position = Vector2(200,250)
	$Characters/Hero.scale *= 0.3
	pass

func EnemyTurn():
	Hero.CurrentHealth -= Enemy.Damage
	$Characters/Hero/VBoxContainer/HealthBar/TextureProgressBar.value = 100*Hero.CurrentHealth/Hero.MaxHealth
	$Characters/Hero/VBoxContainer/HealthBar/Count/Background/Number.text = str(Hero.CurrentHealth)
	$AnimationPlayer.play("player_damaged")

func _on_end_of_turn_pressed():
	EnemyTurn()
