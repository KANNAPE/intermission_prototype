class_name BaseHit
extends Resource

enum HitType {
	SMALL,
	MEDIUM,
	LARGE,
}

enum HitEffect {
	NONE
}

@export var type: HitType
@export var duration: float				# duration of the hit, will block inputs
@export var startup_time: float			# time window before the skill hits
@export var expiring_window: float		# time window after which the skill resets
@export var effect: HitEffect
@export var damage: float

func _init(
		p_type = HitType.MEDIUM,
		p_duration = 0.0,
		p_startup_time = 0.0,
		p_expiring_window = 0.0,
		p_effect = HitEffect.NONE,
		p_damage = 0.0) -> void:
	type = p_type
	duration = p_duration
	startup_time = p_startup_time
	expiring_window = p_expiring_window
	effect = p_effect
	damage = p_damage
