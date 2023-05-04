extends Node

const CardBase   = preload("res://Cards/CardBase.tscn")

@export var deck: TextureButton
@export var discard: Node

@onready var ViewportSize: Vector2 = Vector2(get_viewport().size)
@onready var CenterCardOval = ViewportSize * Vector2(0.5, 1.25)
@onready var Hor_rad = ViewportSize.x * 0.45
@onready var Ver_rad = ViewportSize.y * 0.3

var angle               = 0
var CardSpread          = 0.25
var cards_in_hand_count = -1
var card_number         = 0
var OvalAngleVector     = Vector2()

@onready var DiscardPosition: Vector2 = discard.position
func draw_card(card: Card):
	angle = PI / 2 + CardSpread * (float(cards_in_hand_count) / 2 - cards_in_hand_count) + 0.25

	var new_card = CardBase.instantiate()
	new_card.Cardname = card.name
	new_card.position = deck.position - Globals.CardSize / 2
	new_card.DiscardPile = DiscardPosition - Globals.CardSize / 2
	new_card.scale *= Globals.CardSize/new_card.size
	new_card.state = Globals.CardState.MoveDrawnCardToHand

	card_number = 0
	add_child(new_card)
	cards_in_hand_count += 1
	OrganiseHand()

func OrganiseHand():
	for Card in get_children():
		angle = PI/2 + CardSpread*(float(cards_in_hand_count)/2 - card_number)
		OvalAngleVector = Vector2(Hor_rad * cos(angle), - Ver_rad * sin(angle))

		Card.targetpos = CenterCardOval + OvalAngleVector - Globals.CardSize
		Card.Cardpos = Card.targetpos
		Card.startrot = Card.rotation
		Card.targetrot = (PI / 2 - angle) / 4
		Card.Card_Numb = card_number
		card_number += 1
		if Card.state == Globals.CardState.InHand:
			Card.setup = true
			Card.state = Globals.CardState.ReOrganiseHand
		elif Card.state == Globals.CardState.MoveDrawnCardToHand:
			Card.startpos = (Card.targetpos - (Card.targetpos - Card.position/(1-Card.t)))
