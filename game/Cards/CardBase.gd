extends MarginContainer


# Declare member variables here. Examples:
onready var CardDatabase = preload("res://Assets/Cards/CardsDatabase.gd")
var Cardname = "Atak_1"
onready var CardInfo = CardDatabase.DATA[CardDatabase.get(Cardname)]
onready var CardImg = str("res://Assets/Cards/",CardInfo[0],"/",Cardname,".png")
var startpos = 0
var targetpos = 0
var startrot = 0
var targetrot = 0
var t = 0
var DrawTime = 1
var OrganiseTime = 0.5
onready var Orig_scale = rect_scale
enum{
	InHand
	InPlay
	InMouse
	FocusInHand
	MoveDrawnCardToHand
	ReOrganiseHand
	MoveDrawnCardToDiscard
}
var state = InHand
# Called when the node enters the scene tree for the first time.
func _ready():
	print(CardInfo)
	var CardSize = rect_size
	$Border.scale *= CardSize/$Border.texture.get_size()
	$Card.texture = load(CardImg)
	$Card.scale *= CardSize/$Card.texture.get_size()
	$CardBack.scale *= CardSize/$CardBack.texture.get_size()
	$Focus.rect_scale *= CardSize/$Focus.rect_size
	var Name = str(CardInfo[1])
	var Value = str(CardInfo[2])
	var Cost = str(CardInfo[3])
	var Type = str(CardInfo[4])
	$Bars/TopBar/Name/CenterContainer/Name.text = Name
	$Bars/TopBar/Cost/CenterContainer/Cost.text = Cost
	$Bars/SpecialText/Type/CenterContainer/Type.text = Type
	$Bars/BottomBar/Value/CenterContainer/Value.text = Value
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
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
						var CardSlots = $'../../CardSlots'
						var CardSlotEmpty = $'../../'.CardSlotEmpty
						for i in range(CardSlots.get_child_count()):
							if CardSlotEmpty[i]:
								var CardSlotPos = CardSlots.get_child(i).rect_position
								var CardSlotSize = CardSlots.get_child(i).rect_size
								var mousepos = get_global_mouse_position()
								if mousepos.x < CardSlotPos.x + CardSlotSize.x && mousepos.x > CardSlotPos.x \
									&& mousepos.y < CardSlotPos.y + CardSlotSize.y && mousepos.y > CardSlotPos.y:
										setup = true
										MovingtoInPlay = true
										targetpos = CardSlotPos - $'../../'.CardSize/2
										targetscale = CardSlotSize/rect_size
										state = InPlay
										Card_Select = true
										break
						if state != InPlay:
							setup = true
							targetpos = Cardpos
							state = ReOrganiseHand
							Card_Select = true
					else: 
						var Enemies = $'../../Enemies'
						for i in range(Enemies.get_child_count()):
							var EnemyPos = Enemies.get_child(i).rect_position
							var EnemySize = Enemies.get_child(i).rect_size
							var mousepos = get_global_mouse_position()
							if mousepos.x < EnemyPos.x + EnemySize.x && mousepos.x > EnemyPos.x \
								&& mousepos.y < EnemyPos.y + EnemySize.y && mousepos.y > EnemyPos.y:
									var AttackNo = int($Bars/BottomBar/Value/CenterContainer/Value.text.left(1))
									Enemies.get_child(i).ChangeHealth(AttackNo)
									setup = true
									MovingtoDiscard = true
									state = MoveDrawnCardToDiscard
									#MovingtoInPlay = true
									#state = InPlay
									Card_Select = true
									break
						if Card_Select == false:
							setup = true
							MovingtoInPlay = true
							state = InPlay
							Card_Select = true
			

func _physics_process(delta):
	match state:
		InHand:
			pass
		InPlay:
			if MovingtoInPlay:
				if setup:
					Setup()
				if t <= 1:
					rect_position = startpos.linear_interpolate(targetpos, t)
					rect_rotation = startrot * (1-t) + 0*t
					rect_scale = startscale*(1-t)+targetscale*t
					t += delta/float(InMouseTime)
				else:
					rect_position = targetpos
					rect_rotation = 0
					rect_scale = targetscale
					MovingtoInPlay = false
		InMouse:
			if setup:
				Setup()
			if t <= 1:
				rect_position = startpos.linear_interpolate(get_global_mouse_position() - $'../../'.CardSize, t)
				rect_rotation = startrot * (1-t) + 0*t
				rect_scale = startscale*(1-t)+Orig_scale*t
				t += delta/float(InMouseTime)
			else:
				rect_position = get_global_mouse_position() - $'../../'.CardSize
				rect_rotation = 0
		FocusInHand:
			if setup:
				Setup()
			if t <= 1:
				rect_position = startpos.linear_interpolate(targetpos, t)
				rect_rotation = startrot * (1-t) + 0*t
				rect_scale = startscale * (1-t) + Orig_scale*2*t
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
				rect_position = targetpos
				rect_rotation = targetrot
				rect_scale = Orig_scale*2
		MoveDrawnCardToHand:
			if setup:
				Setup()
			if t <= 1:
				rect_position = startpos.linear_interpolate(targetpos, t)
				rect_rotation = startrot * (1-t) + targetrot*t
				rect_scale.x = Orig_scale.x*abs(2*t-1)
				if $CardBack.visible:
					if t > 0.5:
						$CardBack.visible = false
				t += delta/float(DrawTime)
			else:
				rect_position = targetpos
				rect_rotation = targetrot
				state = InHand
		ReOrganiseHand:
			if setup:
				Setup()
			if t <= 1:
				if Move_Neighbour_Card_Check == true:
					Move_Neighbour_Card_Check = false
				rect_position = startpos.linear_interpolate(targetpos, t)
				rect_rotation = startrot * (1-t) + targetrot*t
				rect_scale = startscale * (1-t) + Orig_scale*t
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
				rect_position = targetpos
				rect_rotation = targetrot
				rect_scale = Orig_scale
				state = InHand
		MoveDrawnCardToDiscard:
			if MovingtoDiscard:
				if setup:
					Setup()
					targetpos = DiscardPile
				if t <= 1:
					rect_position = startpos.linear_interpolate(targetpos, t)
					rect_scale = startscale*(1-t)+Orig_scale*t
					t += delta/float(DrawTime)
				else:
					rect_position = targetpos
					rect_scale = Orig_scale
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
	startpos = rect_position
	startrot = rect_rotation
	startscale = rect_scale
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
