class_name BaseHit
extends Resource

enum HitType {
	SMALL,
	MEDIUM,
	LARGE,
}

@export var type: HitType
@export var duration: float         # duration of the hit, will block inputs
@export var expiring_window: float  # time window after which the skill resets
@export var effect: String
@export var damage: float

func _init(
		p_type = HitType.MEDIUM,
		p_duration = 0.0,
		p_expiring_window = 0.0,
		p_effect = "",
		p_damage = 0.0) -> void:
	type = p_type
	duration = p_duration
	expiring_window = p_expiring_window
	effect = p_effect
	damage = p_damage
