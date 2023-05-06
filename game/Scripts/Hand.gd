extends Node

const CardBase   = preload("res://Cards/CardBase.tscn")

@export var deck: TextureButton
@export var discard_pile: TextureButton

@onready var ViewportSize: Vector2 = Vector2(get_viewport().size)
@onready var CenterCardOval = ViewportSize * Vector2(0.5, 1.25)
@onready var Hor_rad = ViewportSize.x * 0.45
@onready var Ver_rad = ViewportSize.y * 0.3

var angle           = 0
var CardSpread      = 0.25
var card_count      = 0
var OvalAngleVector = Vector2()


@onready var DiscardPosition: Vector2 = discard_pile.position
func draw_card(card: Card):
	var new_card = CardBase.instantiate()
	new_card.hand = self
	new_card.Cardname = card.name
	new_card.position = deck.position - Globals.CardSize / 2
	new_card.DiscardPile = DiscardPosition - Globals.CardSize / 2
	new_card.scale *= Globals.CardSize/new_card.size
	new_card.state = Globals.CardState.MoveDrawnCardToHand

	add_child(new_card)
	card_count += 1
	_organize_hand()


func on_card_played(card: MarginContainer):
	remove_child(card)
	card_count -= 1

	discard_pile.discard(card.card_data)

	_organize_hand()


func _organize_hand():
	var card_index: int = 0
	for Card in get_children():
		angle = PI / 2 + CardSpread * (float(card_count) / 2 - card_index)
		OvalAngleVector = Vector2(Hor_rad * cos(angle), - Ver_rad * sin(angle))

		Card.targetpos = CenterCardOval + OvalAngleVector - Globals.CardSize
		Card.Cardpos = Card.targetpos
		Card.startrot = Card.rotation
		Card.targetrot = (PI / 2 - angle) / 4
		Card.card_index = card_index
		card_index += 1

		if Card.state == Globals.CardState.InHand:
			Card.setup = true
			Card.state = Globals.CardState.ReOrganiseHand
		elif Card.state == Globals.CardState.MoveDrawnCardToHand:
			Card.startpos = (Card.targetpos - (Card.targetpos - Card.position/(1-Card.t)))
