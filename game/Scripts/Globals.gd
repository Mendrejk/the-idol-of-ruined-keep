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
