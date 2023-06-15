extends Resource

enum {
	AttackWeak,
	AttackNormal,
	AttackStrong,
	Heal
}

var Cards: Dictionary = {
	AttackWeak : Card.new("Units","AttackWeak", 1, 1, "Akcja", "Pchnięcie"),
	AttackNormal : Card.new("Units","AttackNormal", 2, 2, "Akcja", "Garda"),
	AttackStrong : Card.new("Units","AttackStrong", 3, 3, "Akcja", "Potężny Cios"),
	Heal: Card.new("Units", "Heal", 0, 2, "Akcja", "Leczenie: 4")
}
