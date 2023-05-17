extends MarginContainer


var CurrentHealth = 10
var MaxHealth = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#$VBoxContainer/ImageContainer/Image.scale *= $VBoxContainer/ImageContainer.rect_min_size/$VBoxContainer/ImageContainer/Image.texture.get_size()
	$VBoxContainer/Bar/TextureProgressBar.value = 100
	$VBoxContainer/Bar/Count/Number.text = str(CurrentHealth)

#func ChangeHeroHealth(Number):
#	CurrentHealth -= Number
#	$VBoxContainer/HealthBar/TextureProgressBar.value = 100*CurrentHealth/MaxHealth
#	$VBoxContainer/HealthBar/Count/Background/Number.text = str(CurrentHealth)
	
