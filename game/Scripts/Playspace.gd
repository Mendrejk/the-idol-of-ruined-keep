extends Node2D

@onready var ViewportSize: Vector2 = Vector2(get_viewport().size)
@onready var hero = $Characters/Hero
@onready var deck: TextureButton = $Deck
@onready var discard_pile: TextureButton = $DiscardPile
var mana_max_value = 0
var mana_value = mana_max_value
var enemy
var dodge_chance

func _ready():
	print(Globals.map_length)
	deck.deck_emptied.connect(_on_deck_emptied)
	if Globals.level_number == 0:
		Globals.enemy_number = 0
		var global_enemy = $Enemies.get_child(Globals.enemy_number)
		enemy = global_enemy
	elif Globals.level_number < ((Globals.map_length*Globals.map_miniboss_length_ratio)-1):
		Globals.enemy_number = randi()%2
		var global_enemy = $Enemies.get_child(Globals.enemy_number)
		enemy = global_enemy
	elif Globals.level_number < ((Globals.map_length*Globals.map_miniboss_length_ratio)-1):
		Globals.enemy_number = randi()%2+1
		var global_enemy = $Enemies.get_child(Globals.enemy_number)
		enemy = global_enemy
	elif Globals.level_number == ((Globals.map_length*Globals.map_miniboss_length_ratio)-1):
		Globals.enemy_number = 3
		var global_enemy = $Enemies.get_child(Globals.enemy_number)
		enemy = global_enemy
	elif Globals.level_number < Globals.map_length-1:
		Globals.enemy_number = 2
		var global_enemy = $Enemies.get_child(Globals.enemy_number)
		enemy = global_enemy
	elif Globals.level_number == Globals.map_length-1:
		Globals.enemy_number = 4
		var global_enemy = $Enemies.get_child(Globals.enemy_number)
		enemy = global_enemy
	elif Globals.level_number == 5:
		get_tree().change_scene_to_file("res://Scenes/StartMenu.tscn")
	randomize()
	enemy.visible = true
	hero.visible = true
	# Draw some cards at the start of fight
	for i in range(Globals.player_starting_hand_size):
		deck.draw_card()
		$Draw.play()

	Increase_Max_Mana()



func EnemyTurn():
	$Draw.play()
	dodge_chance = randi()%3+1
	enemy.EnemyAttack()
	if dodge_chance == 1:
		$HeroIndicator.visible = true
		$HeroIndicator.text = "Unik!"
		await get_tree().create_timer(1).timeout
		$HeroIndicator.visible = false
	else:
		hero.ChangeHeroHealth(enemy.Damage)
		$HeroIndicator.visible = true
		$HeroIndicator.add_theme_color_override("font_color", Color(255,0,0))
		$HeroIndicator.text = "-"+str(enemy.Damage)
		await get_tree().create_timer(1).timeout
		$HeroIndicator.add_theme_color_override("font_color", Color(255,255,255))
		$HeroIndicator.visible = false
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
	$PlayerPanel/Playerdata/TextureProgressBar.value = mana_value
	$PlayerPanel/Playerdata/TextureProgressBar/Mana.text = str(mana_value)
	$PlayerPanel/Playerdata/TextureProgressBar/MaxMana.text = str(mana_value)
