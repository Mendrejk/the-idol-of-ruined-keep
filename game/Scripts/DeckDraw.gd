extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var DeckSize = INF

# Called when the node enters the scene tree for the first time.
func _ready():
	scale *= $'../../'.CardSize/size

func _gui_input(event):
	if Input.is_action_just_released("leftclick"):
		if DeckSize > 0:
			DeckSize = $'../../'.drawcard()
			if DeckSize == 0:
				disabled = true
