extends TextureButton

var cardDatabase: Resource = preload("res://Assets/Cards/CardsDatabase.gd").new()

@export var drawer: Node2D

var cards: Array[Card] = _create_populated_deck()

# Called when the node enters the scene tree for the first time.
func _ready():
	scale *= Globals.CardSize / size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_gui_input(event):
	if Input.is_action_just_released("leftclick"):
		if not cards.is_empty():
			drawer.draw_card(cards.pop_back())

			if cards.is_empty():
				disabled = true

func _create_populated_deck() -> Array[Card] :
	# TODO: in the future, this should not be hardcoded
	var attack_weak = cardDatabase.Cards[cardDatabase.AttackWeak]
	var attack_normal = cardDatabase.Cards[cardDatabase.AttackNormal]
	var attack_strong = cardDatabase.Cards[cardDatabase.AttackStrong]

	var cards: Array[Card] = [attack_weak, attack_weak, attack_normal, attack_normal, attack_strong, attack_strong]
	randomize()
	cards.shuffle()

	return cards
