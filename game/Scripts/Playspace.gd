extends Node2D

@export var deck: TextureButton

const CardBase   = preload("res://Cards/CardBase.tscn")
const PlayerHand = preload("res://Cards/Player_Hand.gd")

var CardSelected = []
@onready var DeckSize = PlayerHand.CardList.size()

@onready var ViewportSize = Vector2(get_viewport().size)
@onready var CenterCardOval = ViewportSize * Vector2(0.5, 1.25)
@onready var Hor_rad = ViewportSize.x * 0.45
@onready var Ver_rad = ViewportSize.y * 0.3

var Hero = load("res://Scripts/Hero.gd").new()
var Enemy = load("res://Scripts/Enemy.gd").new()

var angle               = 0
var CardSpread          = 0.25
var cards_in_hand_count = -1
var card_number         = 0
var OwalAngleVector     = Vector2()

enum{
	InHand,
	InPlay,
	InMouse,
	FocusInHand,
	MoveDrawnCardToHand,
	ReOrganiseHand,
	MoveDrawnCardToDiscard
}

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Enemies/Enemy.visible = true
	$Enemies/Enemy.position = ViewportSize * 0.4 + Vector2(200,0)
	$Enemies/Enemy.scale *= 0.3
	$Characters/Hero.visible = true
	$Characters/Hero.position = Vector2(200,250)
	$Characters/Hero.scale *= 0.3
	pass

@onready var DiscardPosition: Vector2 = $Discard.position
func draw_card(card: Card):
	angle = PI / 2 + CardSpread * (float(cards_in_hand_count) / 2 - cards_in_hand_count) + 0.25

	var new_card = CardBase.instantiate()
	new_card.Cardname = card.name
	new_card.position = deck.position - Globals.CardSize / 2
	new_card.DiscardPile = DiscardPosition - Globals.CardSize / 2
	new_card.scale *= Globals.CardSize/new_card.size
	new_card.state = MoveDrawnCardToHand

	card_number = 0
	$Cards.add_child(new_card)
#	PlayerHand.CardList.erase(PlayerHand.CardList[CardSelected])
	DeckSize -= 1
	cards_in_hand_count += 1
	OrganiseHand()

func OrganiseHand():
	for Card in $Cards.get_children():
		angle = PI/2 + CardSpread*(float(cards_in_hand_count)/2 - card_number)
		OwalAngleVector = Vector2(Hor_rad * cos(angle), - Ver_rad * sin(angle))
		
		Card.targetpos = CenterCardOval + OwalAngleVector - Globals.CardSize
		Card.Cardpos = Card.targetpos
		Card.startrot = Card.rotation
		Card.targetrot = (PI / 2 - angle) / 4 
		Card.Card_Numb = card_number
		card_number += 1
		if Card.state == InHand:
			Card.setup = true
			Card.state = ReOrganiseHand
		elif Card.state == MoveDrawnCardToHand:
			Card.startpos = (Card.targetpos - (Card.targetpos - Card.position/(1-Card.t)))

func EnemyTurn():
	Hero.CurrentHealth -= Enemy.Damage
	$Characters/Hero/VBoxContainer/HealthBar/TextureProgressBar.value = 100*Hero.CurrentHealth/Hero.MaxHealth
	$Characters/Hero/VBoxContainer/HealthBar/Count/Background/Number.text = str(Hero.CurrentHealth)
	$AnimationPlayer.play("player_damaged")

func _on_end_of_turn_pressed():
	EnemyTurn()
