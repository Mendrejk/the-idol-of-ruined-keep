extends MarginContainer


var CurrentHealth = 10
var MaxHealth = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#$VBoxContainer/ImageContainer/Image.scale *= $VBoxContainer/ImageContainer.rect_min_size/$VBoxContainer/ImageContainer/Image.texture.get_size()
	$VBoxContainer/Bar/TextureProgressBar.value = 100
	$VBoxContainer/Bar/Count/Number.text = str(CurrentHealth)
	$VBoxContainer/ImageContainer/AnimatedSprite2D.play("idle")

func ChangeHeroHealth(Number):
	CurrentHealth -= Number
	$VBoxContainer/Bar/TextureProgressBar.value = 100*CurrentHealth/MaxHealth
	$VBoxContainer/Bar/Count/Number.text = str(CurrentHealth)
	$Hit.play()
	$'../../AnimationPlayer'.play("player_damaged")
	$VBoxContainer/ImageContainer/AnimatedSprite2D.play("hurt")
	await $VBoxContainer/ImageContainer/AnimatedSprite2D.animation_finished
	$VBoxContainer/ImageContainer/AnimatedSprite2D.play("idle")

func heal(Number):
	CurrentHealth += Number
	if CurrentHealth > MaxHealth:
		CurrentHealth = MaxHealth
	$VBoxContainer/Bar/TextureProgressBar.value = 100*CurrentHealth/MaxHealth
	$VBoxContainer/Bar/Count/Number.text = str(CurrentHealth)

func HeroAttack():
	$SwordAttack1.play()
	$VBoxContainer/ImageContainer/AnimatedSprite2D.play("attack")
	await $VBoxContainer/ImageContainer/AnimatedSprite2D.animation_finished
	$VBoxContainer/ImageContainer/AnimatedSprite2D.play("idle")
