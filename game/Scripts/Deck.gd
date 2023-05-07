extends TextureButton

var cardDatabase: Resource = preload("res://Assets/Cards/CardsDatabase.gd").new()

@export var drawer: Node
@export var discard_pile: TextureButton

var cards: Array[Card] = _create_populated_deck()


func _ready():
	scale *= Globals.CardSize / size


func _on_end_of_turn_pressed():
	draw()


func draw():
	if not cards.is_empty():
		drawer.draw_card(cards.pop_back())

		if cards.is_empty():
			disabled = true


func _create_populated_deck() -> Array[Card]:
	# TODO: in the future, this should not be hardcoded
	var attack_weak   = cardDatabase.Cards[cardDatabase.AttackWeak]
	var attack_normal = cardDatabase.Cards[cardDatabase.AttackNormal]
	var attack_strong = cardDatabase.Cards[cardDatabase.AttackStrong]

	var cards: Array[Card] = [attack_weak, attack_weak, attack_normal, attack_normal, attack_strong, attack_strong]
	randomize()
	cards.shuffle()

	return cards
