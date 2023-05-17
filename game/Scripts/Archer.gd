extends MarginContainer


var CurrentHealth = 8
var MaxHealth = 8
var Damage = 2


func _ready():
	pass
	#$VBoxContainer/ImageContainer/Image.scale *= $VBoxContainer/ImageContainer.rect_min_size/$VBoxContainer/ImageContainer/Image.texture.get_size()
	$VBoxContainer/Bar/TextureProgressBar.value = 100
	$VBoxContainer/Bar/Count/Number.text = str(CurrentHealth)


func ChangeEnemyHealth(Number):
	CurrentHealth -= Number
	$VBoxContainer/Bar/TextureProgressBar.value = 100*CurrentHealth/MaxHealth
	$VBoxContainer/Bar/Count/Number.text = str(CurrentHealth)
	$'../../AnimationPlayer'.play("enemy_damaged")
	
	if CurrentHealth <= 0:
		get_tree().change_scene_to_file("res://Scenes/Map.tscn")
