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

var level_number = 0

# Map globals
const map_min_length: int = 9
const map_max_length: int = 11
const map_miniboss_length_ratio: float = 0.7
 
const map_max_deepness_level: int = 3
const map_deepen_chance: float = 0.3
const map_shallow_chance: float = 0.3

var map_provider: TempMapProvider = TempMapProvider.new()
