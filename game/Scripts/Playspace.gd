extends Node2D

@onready var ViewportSize: Vector2 = Vector2(get_viewport().size)
@onready var hero = $Characters/Hero
@onready var enemy = $Enemies/Enemy
@onready var deck: TextureButton = $Deck
@onready var discard_pile: TextureButton = $DiscardPile


func _ready():
	deck.deck_emptied.connect(_on_deck_emptied)

	randomize()
	enemy.visible = true
	enemy.position = ViewportSize * 0.4 + Vector2(200, 0)
	enemy.scale *= 0.3
	hero.visible = true
	hero.position = Vector2(200, 250)
	hero.scale *= 0.3
	pass


func EnemyTurn():
	hero.CurrentHealth -= enemy.Damage
	$Characters/Hero/VBoxContainer/HealthBar/TextureProgressBar.value = 100 * hero.CurrentHealth / hero.MaxHealth
	$Characters/Hero/VBoxContainer/HealthBar/Count/Background/Number.text = str(hero.CurrentHealth)
	$AnimationPlayer.play("player_damaged")


func _on_end_of_turn_pressed():
	EnemyTurn()


func _on_deck_emptied():
	var cards_from_discard_pile: Array[Card] = discard_pile.empty()
	cards_from_discard_pile.shuffle()
	deck.refill(cards_from_discard_pile)
