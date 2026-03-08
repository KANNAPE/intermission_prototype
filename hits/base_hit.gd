class_name BaseHit
extends Resource

enum HitType {
	SMALL,
	MEDIUM,
	LARGE,
}

enum HitEffect {
	NOTHING
}

@export var type: HitType
@export var duration: float				# duration of the hit, will block inputs
@export var windup_time: float		# time window before the skill hits
@export var expiring_window: float		# time window after which the skill resets
@export var effect: HitEffect
@export var damage: float

func _init(
		p_type = HitType.MEDIUM,
		p_duration = 0.0,
		p_windup_time = 0.0,
		p_expiring_window = 0.0,
		p_effect = HitEffect.NOTHING,
		p_damage = 0.0) -> void:
	type = p_type
	duration = p_duration
	windup_time = p_windup_time
	expiring_window = p_expiring_window
	effect = p_effect
	damage = p_damage
