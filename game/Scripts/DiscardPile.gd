extends TextureButton

var _discard_pile: Array[Card] = []
# disabled changes the texture (true = empty)

func _ready():
	scale *= Globals.CardSize / size
	disabled = true

func discard(card: Card):
	_discard_pile.push_back(card)
	disabled = false

func empty() -> Array[Card]:
	var emptied_cards: Array[Card] = _discard_pile
	_discard_pile = []
	disabled = true

	return emptied_cards
