extends MarginContainer


var CurrentHealth = 15
var MaxHealth = 15
var Damage = 3
var DodgeChance = 10

func _ready():
	pass
	#$VBoxContainer/ImageContainer/Image.scale *= $VBoxContainer/ImageContainer.rect_min_size/$VBoxContainer/ImageContainer/Image.texture.get_size()
	$VBoxContainer/Bar/TextureProgressBar.value = 100
	$VBoxContainer/Bar/Count/Number.text = str(CurrentHealth)
	$VBoxContainer/ImageContainer/AnimatedSprite2D.play("idle")


func ChangeEnemyHealth(Number):
	CurrentHealth -= Number
	$VBoxContainer/Bar/TextureProgressBar.value = 100*CurrentHealth/MaxHealth
	$VBoxContainer/Bar/Count/Number.text = str(CurrentHealth)
	$Hit.play()
	$'../../AnimationPlayer'.play("enemy_damaged")
	$VBoxContainer/ImageContainer/AnimatedSprite2D.play("hurt")
	await $VBoxContainer/ImageContainer/AnimatedSprite2D.animation_finished
	$VBoxContainer/ImageContainer/AnimatedSprite2D.play("idle")
	if CurrentHealth <= 0:
		get_tree().change_scene_to_file("res://Scenes/StartMenu.tscn")

func EnemyAttack():
	Damage = randi()%3+1
	$SwordAttack1.play()
	$VBoxContainer/ImageContainer/AnimatedSprite2D.play("attack")
	await $VBoxContainer/ImageContainer/AnimatedSprite2D.animation_finished
	$VBoxContainer/ImageContainer/AnimatedSprite2D.play("idle")
