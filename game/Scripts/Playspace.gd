extends Node2D

@onready var ViewportSize: Vector2 = Vector2(get_viewport().size)
@onready var hero = $Characters/Hero
@onready var enemy = $Enemies/Enemy
@onready var deck: TextureButton = $Deck
@onready var discard_pile: TextureButton = $DiscardPile
var mana_max_value = 0
var mana_value = mana_max_value

func _ready():
	deck.deck_emptied.connect(_on_deck_emptied)

	randomize()
	enemy.visible = true
	enemy.position = ViewportSize * 0.4 + Vector2(200, 0)
	enemy.scale *= 0.3
	hero.visible = true
	hero.position = Vector2(200, 250)
	hero.scale *= 0.3

	# Draw some cards at the start of fight
	for i in range(Globals.player_starting_hand_size):
		deck.draw_card()

	Increase_Max_Mana()


func EnemyTurn():
	hero.CurrentHealth -= enemy.Damage
	$Characters/Hero/VBoxContainer/HealthBar/TextureProgressBar.value = 100 * hero.CurrentHealth / hero.MaxHealth
	$Characters/Hero/VBoxContainer/HealthBar/Count/Background/Number.text = str(hero.CurrentHealth)
	$AnimationPlayer.play("player_damaged")
	if hero.CurrentHealth <= 0:
		get_tree().change_scene_to_file("res://Scenes/Defeat.tscn")

func _on_end_of_turn_pressed():
	EnemyTurn()
	Increase_Max_Mana()

func _on_deck_emptied():
	var cards_from_discard_pile: Array[Card] = discard_pile.empty()
	cards_from_discard_pile.shuffle()
	deck.refill(cards_from_discard_pile)

func Increase_Max_Mana():
	if mana_max_value < 10:
		mana_max_value += 1;
		mana_value = mana_max_value
	else:
		mana_value = mana_max_value
	Load_Mana()

func Decrease_Mana(value):
	if mana_value > 0:
		mana_value -= value;

func Load_Mana():
	$PlayerPanel/Playerdata/ProgressBar.value = mana_value
	$PlayerPanel/Playerdata/ProgressBar/Label.text = str(mana_value)
