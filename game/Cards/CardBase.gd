extends MarginContainer


@onready var CardDatabase = preload("res://Assets/Cards/CardsDatabase.gd")
@onready var CardDatabaseInstance = CardDatabase.new()

var Cardname = "Atak_1"

@onready var CardInfo = CardDatabaseInstance.DATA[CardDatabaseInstance.get(Cardname)]
@onready var CardImg = str("res://Assets/Cards/",CardInfo[0],"/",Cardname,".png")

var startpos = 0
var targetpos = 0
var startrot = 0
var targetrot = 0
var t = 0
var DrawTime = 1
var OrganiseTime = 0.5
@onready var Orig_scale = scale

enum{
	InHand,
	InPlay,
	InMouse,
	FocusInHand,
	MoveDrawnCardToHand,
	ReOrganiseHand,
	MoveDrawnCardToDiscard
}

var state = InHand
# Called when the node enters the scene tree for the first time.
func _ready():
	print(CardInfo)
	var CardSize = size
	$Border.scale *= CardSize/$Border.texture.get_size()
	$Card.texture = load(CardImg)
	
	var ScaledCardSize = CardSize / $Card.texture.get_size()
	$Card.scale *= ScaledCardSize
	
	$CardBack.scale *= CardSize/$CardBack.texture.get_size()
	print($Focus.scale, CardSize, $Focus.size)
	$Focus.set_stretch_mode(TextureButton.STRETCH_SCALE)
	$Focus.set_scale( $Focus.scale * CardSize / $Focus.size)
	print($Focus.scale)
	
	var Name = str(CardInfo[1])
	var Value = str(CardInfo[2])
	var Cost = str(CardInfo[3])
	var Type = str(CardInfo[4])
	$Bars/TopBar/Name/CenterContainer/Name.text = Name
	$Bars/TopBar/Cost/CenterContainer/Cost.text = Cost
	$Bars/SpecialText/Type/CenterContainer/Type.text = Type
	$Bars/BottomBar/Value/CenterContainer/Value.text = Value
	
	original_scale = scale

var setup = true
var startscale = Vector2()
var Cardpos = Vector2()
var ZoomInSize = 2
var ZoomTime = 0.2
var ReorganiseNeighbours = true
var NumberCardsHand = 0
var Card_Numb = 0
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
		FocusInHand, InMouse, InPlay:
			if event.is_action_pressed("leftclick"):
				if Card_Select:
					oldstate = state
					state = InMouse
					setup = true
					Card_Select = false
			if event.is_action_released("leftclick"):
				if Card_Select == false:
					if oldstate == FocusInHand:
						if is_in_play_area:
							setup = true
							MovingtoInPlay = true
							state = InPlay
							Card_Select = true

							# TODO: add some enemy select mechanic if there are more enemies
							var first_enemy = $'../../Enemies'.get_child(0)
							var AttackNo = int($Bars/BottomBar/Value/CenterContainer/Value.text.left(1))
							first_enemy.ChangeBanditHealth(AttackNo)
							setup = true
							MovingtoDiscard = true
							state = MoveDrawnCardToDiscard
							Card_Select = true
						else:
							setup = true
							targetpos = Cardpos
							state = ReOrganiseHand
							Card_Select = true

							if is_in_play_area:
								scale = original_scale
								is_in_play_area = false


func _process(delta):
	if state == InMouse:
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
		InHand:
			pass
		InPlay:
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
		InMouse:
			if setup:
				Setup()
			if t <= 1:
				position = startpos.lerp(get_global_mouse_position() - $'../../'.CardSize, t)
				rotation = startrot * (1-t) + 0*t
				scale = startscale*(1-t)+Orig_scale*t
				t += delta/float(InMouseTime)
			else:
				position = get_global_mouse_position() - $'../../'.CardSize
				rotation = 0
		FocusInHand:
			if setup:
				Setup()
			if t <= 1:
				position = startpos.lerp(targetpos, t)
				rotation = startrot * (1-t) + 0*t
				scale = startscale * (1-t) + Orig_scale*2*t
				t += delta/float(ZoomTime)
				if ReorganiseNeighbours:
					ReorganiseNeighbours = false
					NumberCardsHand = $'../../'.NumberCardsHand - 1
					if Card_Numb - 1 >= 0:
						Move_Neighbour_Card(Card_Numb - 1,true,1)
					if Card_Numb - 2 >= 0:
						Move_Neighbour_Card(Card_Numb - 2,true,0.25)
					if Card_Numb + 1 <= NumberCardsHand:
						Move_Neighbour_Card(Card_Numb + 1,false,1)
					if Card_Numb + 2 <= NumberCardsHand:
						Move_Neighbour_Card(Card_Numb + 2,false,0.25)
			else:
				position = targetpos
				rotation = targetrot
				scale = Orig_scale*2
		MoveDrawnCardToHand:
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
				state = InHand
		ReOrganiseHand:
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
					if Card_Numb - 1 >= 0:
						Reset_Card(Card_Numb - 1)
					if Card_Numb - 2 >= 0:
						Reset_Card(Card_Numb - 2)
					if Card_Numb + 1 <= NumberCardsHand:
						Reset_Card(Card_Numb + 1)
					if Card_Numb + 2 <= NumberCardsHand:
						Reset_Card(Card_Numb + 2)
			else:
				position = targetpos
				rotation = targetrot
				scale = Orig_scale
				state = InHand
		MoveDrawnCardToDiscard:
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
					
func Move_Neighbour_Card(Card_Numb,Left,Spreadfactor):
	NeighbourCard = $'../'.get_child(Card_Numb)
	if Left:
		NeighbourCard.targetpos = NeighbourCard.Cardpos - Spreadfactor*Vector2(65,0)
	else:
		NeighbourCard.targetpos = NeighbourCard.Cardpos + Spreadfactor*Vector2(65,0)
	NeighbourCard.setup = true
	NeighbourCard.state = ReOrganiseHand
	NeighbourCard.Move_Neighbour_Card_Check = true

func Reset_Card(Card_Numb):
	NeighbourCard = $'../'.get_child(Card_Numb)
#	if NeighbourCard.Move_Neighbour_Card_Check == true:
#		NeighbourCard.Move_Neighbour_Card_Check = false
	if NeighbourCard.Move_Neighbour_Card_Check == false:
		NeighbourCard = $'../'.get_child(Card_Numb)
		if NeighbourCard.state != FocusInHand:
			NeighbourCard.state = ReOrganiseHand
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
		InHand, ReOrganiseHand:
			setup = true
			targetpos = Cardpos
			targetpos.y = get_viewport().size.y - $'../../'.CardSize.y*ZoomInSize
			state = FocusInHand


func _on_Focus_mouse_exited():
	match state:
		FocusInHand:
			setup = true
			targetpos = Cardpos
			state = ReOrganiseHand
