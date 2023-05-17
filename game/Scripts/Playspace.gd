extends Node2D

@onready var ViewportSize: Vector2 = Vector2(get_viewport().size)
@onready var hero = $Characters/Hero
@onready var deck: TextureButton = $Deck
@onready var discard_pile: TextureButton = $DiscardPile
var mana_max_value = 0
var mana_value = mana_max_value
var enemy

func _ready():
	deck.deck_emptied.connect(_on_deck_emptied)
	if Globals.level_number == 0:
		var global_enemy = $Enemies.get_child(0)
		enemy = global_enemy
	elif Globals.level_number == 1:
		var global_enemy = $Enemies.get_child(1)
		enemy = global_enemy
	elif Globals.level_number == 2:
		var global_enemy = $Enemies.get_child(2)
		enemy = global_enemy
	elif Globals.level_number == 3:
		var global_enemy = $Enemies.get_child(3)
		enemy = global_enemy
	elif Globals.level_number == 4:
		get_tree().change_scene_to_file("res://Scenes/Defeat.tscn")
	randomize()
	enemy.visible = true
	hero.visible = true

	# Draw some cards at the start of fight
	for i in range(Globals.player_starting_hand_size):
		deck.draw_card()

	Increase_Max_Mana()
	
	if Globals.level_number == 0:
		print(Globals.level_number)


func EnemyTurn():
	hero.CurrentHealth -= enemy.Damage
	$Characters/Hero/VBoxContainer/Bar/TextureProgressBar.value = 100 * hero.CurrentHealth / hero.MaxHealth
	$Characters/Hero/VBoxContainer/Bar/Count/Number.text = str(hero.CurrentHealth)
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
