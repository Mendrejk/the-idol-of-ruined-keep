extends TextureButton

var discard_pile: Array[Card] = []
# disabled changes the texture (true = empty)

func _ready():
	scale *= Globals.CardSize / size
	disabled = true

func discard(card: Card):
	discard_pile.push_back(card)
	disabled = false
