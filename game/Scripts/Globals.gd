extends Node

const CardSize: Vector2 = Vector2(125, 175)

enum CardState {
	InHand,
	InPlay,
	InMouse,
	FocusInHand,
	MoveDrawnCardToHand,
	ReOrganiseHand,
	MoveDrawnCardToDiscard
}

# Player globals
var player_starting_hand_size: int = 3
