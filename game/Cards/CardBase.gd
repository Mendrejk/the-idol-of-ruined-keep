extends MarginContainer

var cardDatabase: Resource = preload("res://Assets/Cards/CardsDatabase.gd").new()

var hand = null

var Cardname: String = "AttackWeak"

var card_data: Card

var startpos = 0
var targetpos = 0
var startrot = 0
var targetrot = 0
var t = 0
var DrawTime = 1
var OrganiseTime = 0.5
@onready var Orig_scale = scale

var state = Globals.CardState.InHand


# Called when the node enters the scene tree for the first time.
func _ready():
	card_data = cardDatabase.Cards[cardDatabase.get(Cardname)]
	var card_texture_path: String = str("res://Assets/Cards/", card_data.path, "/", Cardname, ".png")

	# FIXME: I have no idea why the times two is needed here
	size = Globals.CardSize * 2

	$Border.scale *= size / $Border.texture.get_size()

	$Card.texture = load(card_texture_path)
	$Card.scale *= size / $Card.texture.get_size()

	$CardBack.scale *= size / $CardBack.texture.get_size()
	$Focus.set_stretch_mode(TextureButton.STRETCH_SCALE)
	$Focus.set_scale( $Focus.scale * size / $Focus.size)

	$Bars/TopBar/Name/CenterContainer/Name.text = card_data.name
	$Bars/TopBar/Cost/CenterContainer/Cost.text = str(card_data.cost)
	$Bars/SpecialText/Type/CenterContainer/Type.text = card_data.type
	$Bars/BottomBar/Value/CenterContainer/Value.text = str(card_data.value)

	original_scale = scale


var setup = true
var startscale = Vector2()
var Cardpos = Vector2()
var ZoomInSize = 2
var ZoomTime = 0.2
var ReorganiseNeighbours = true
var cards_in_hand_count = 0
var card_index = 0
var NeighbourCard
var Move_Neighbour_Card_Check = false
var Zooming_In = true
var oldstate = INF
var Card_Select = true
var InMouseTime = 0.1
var MovingtoInPlay = false
var targetscale = Vector2()
var DiscardPile = Vector2()
var MovingtoDiscard = false

var is_in_play_area = false
var original_scale = null

func _input(event):
	match state:
		Globals.CardState.FocusInHand, Globals.CardState.InMouse, Globals.CardState.InPlay:
			if event.is_action_pressed("leftclick"):
				if Card_Select:
					oldstate = state
					state = Globals.CardState.InMouse
					setup = true
					Card_Select = false
			if event.is_action_released("leftclick"):
				if Card_Select == false:
					if oldstate == Globals.CardState.FocusInHand:
						if is_in_play_area:
							setup = true
							MovingtoInPlay = true
							state = Globals.CardState.InPlay
							Card_Select = true

							# TODO: add some enemy select mechanic if there are more enemies
							var first_enemy = $'../../Enemies'.get_child(0)
							var AttackNo = int($Bars/BottomBar/Value/CenterContainer/Value.text.left(1))
							first_enemy.ChangeBanditHealth(AttackNo)
							setup = true
							MovingtoDiscard = true
							state = Globals.CardState.MoveDrawnCardToDiscard
							Card_Select = true
							hand.on_card_played(self)
						else:
							setup = true
							targetpos = Cardpos
							state = Globals.CardState.ReOrganiseHand
							Card_Select = true

							if is_in_play_area:
								scale = original_scale
								is_in_play_area = false


func _process(delta):
	if state == Globals.CardState.InMouse:
		var background: Sprite2D = $'../../Background'
		var play_area_bottom: float = 0.8 * background.texture.get_height() * background.scale.y
		var is_mouse_in_play_area: bool = get_global_mouse_position().y <= play_area_bottom
		if is_mouse_in_play_area and not is_in_play_area:
			scale *= 1.5
			is_in_play_area = true
		elif not is_mouse_in_play_area and is_in_play_area:
			scale = original_scale
			is_in_play_area = false

func _physics_process(delta):
	match state:
		Globals.CardState.InHand:
			pass
		Globals.CardState.InPlay:
			if MovingtoInPlay:
				if setup:
					Setup()
				if t <= 1:
					position = startpos.lerp(targetpos, t)
					rotation = startrot * (1-t) + 0*t
					scale = startscale*(1-t)+targetscale*t
					t += delta/float(InMouseTime)
				else:
					position = targetpos
					rotation = 0
					scale = targetscale
					MovingtoInPlay = false
		Globals.CardState.InMouse:
			if setup:
				Setup()
			if t <= 1:
				position = startpos.lerp(get_global_mouse_position() - Globals.CardSize, t)
				rotation = startrot * (1-t) + 0*t
				scale = startscale*(1-t)+Orig_scale*t
				t += delta/float(InMouseTime)
			else:
				position = get_global_mouse_position() - Globals.CardSize
				rotation = 0
		Globals.CardState.FocusInHand:
			if setup:
				Setup()
			if t <= 1:
				position = startpos.lerp(targetpos, t)
				rotation = startrot * (1-t) + 0*t
				scale = startscale * (1-t) + Orig_scale*2*t
				t += delta/float(ZoomTime)
				if ReorganiseNeighbours:
					ReorganiseNeighbours = false
					cards_in_hand_count = hand.card_count - 1
					if card_index - 1 >= 0:
						Move_Neighbour_Card(card_index - 1,true,1)
					if card_index - 2 >= 0:
						Move_Neighbour_Card(card_index - 2,true,0.25)
					if card_index + 1 <= cards_in_hand_count:
						Move_Neighbour_Card(card_index + 1,false,1)
					if card_index + 2 <= cards_in_hand_count:
						Move_Neighbour_Card(card_index + 2,false,0.25)
			else:
				position = targetpos
				rotation = targetrot
				scale = Orig_scale*2
		Globals.CardState.MoveDrawnCardToHand:
			if setup:
				Setup()
			if t <= 1:
				position = startpos.lerp(targetpos, t)
				rotation = startrot * (1-t) + targetrot*t
				scale.x = Orig_scale.x*abs(2*t-1)
				if $CardBack.visible:
					if t > 0.5:
						$CardBack.visible = false
				t += delta/float(DrawTime)
			else:
				position = targetpos
				rotation = targetrot
				state = Globals.CardState.InHand
		Globals.CardState.ReOrganiseHand:
			if setup:
				Setup()
			if t <= 1:
				if Move_Neighbour_Card_Check == true:
					Move_Neighbour_Card_Check = false
				position = startpos.lerp(targetpos, t)
				rotation = startrot * (1-t) + targetrot*t
				scale = startscale * (1-t) + Orig_scale*t
				t += delta/float(OrganiseTime)
				if ReorganiseNeighbours == false:
					ReorganiseNeighbours = true
					if card_index - 1 >= 0:
						Reset_Card(card_index - 1)
					if card_index - 2 >= 0:
						Reset_Card(card_index - 2)
					if card_index + 1 <= cards_in_hand_count:
						Reset_Card(card_index + 1)
					if card_index + 2 <= cards_in_hand_count:
						Reset_Card(card_index + 2)
			else:
				position = targetpos
				rotation = targetrot
				scale = Orig_scale
				state = Globals.CardState.InHand
		Globals.CardState.MoveDrawnCardToDiscard:
			if MovingtoDiscard:
				if setup:
					Setup()
					targetpos = DiscardPile
				if t <= 1:
					position = startpos.lerp(targetpos, t)
					scale = startscale*(1-t)+Orig_scale*t
					t += delta/float(DrawTime)
				else:
					position = targetpos
					scale = Orig_scale
					MovingtoDiscard = false

func Move_Neighbour_Card(card_index,Left,Spreadfactor):
	NeighbourCard = hand.get_child(card_index)
	if Left:
		NeighbourCard.targetpos = NeighbourCard.Cardpos - Spreadfactor*Vector2(65,0)
	else:
		NeighbourCard.targetpos = NeighbourCard.Cardpos + Spreadfactor*Vector2(65,0)
	NeighbourCard.setup = true
	NeighbourCard.state = Globals.CardState.ReOrganiseHand
	NeighbourCard.Move_Neighbour_Card_Check = true

func Reset_Card(card_index):
	NeighbourCard = hand.get_child(card_index)
#	if NeighbourCard.Move_Neighbour_Card_Check == true:
#		NeighbourCard.Move_Neighbour_Card_Check = false
	if NeighbourCard.Move_Neighbour_Card_Check == false:
		NeighbourCard = hand.get_child(card_index)
		if NeighbourCard.state != Globals.CardState.FocusInHand:
			NeighbourCard.state = Globals.CardState.ReOrganiseHand
			NeighbourCard.targetpos = NeighbourCard.Cardpos
			NeighbourCard.setup = true


func Setup():
	startpos = position
	startrot = rotation
	startscale = scale
	t = 0
	setup = false

func _on_Focus_mouse_entered():
	match state:
		Globals.CardState.InHand, Globals.CardState.ReOrganiseHand:
			setup = true
			targetpos = Cardpos
			targetpos.y = get_viewport().size.y - Globals.CardSize.y * ZoomInSize
			state = Globals.CardState.FocusInHand


func _on_Focus_mouse_exited():
	match state:
		Globals.CardState.FocusInHand:
			setup = true
			targetpos = Cardpos
			state = Globals.CardState.ReOrganiseHand
