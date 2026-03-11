class_name BaseHit
extends Resource

enum HitType {
	SMALL,
	MEDIUM,
	LARGE,
}

enum HitForce {
	FEEBLE, 		# will not apply any knockback
	NORMAL,			# will apply staggering
	STRONG			# will apply blowback
}

# List of all status effects the hit can apply, such as Burn, Static, Frozen etc...
enum HitEffect {
	NONE
}

@export var type: HitType
@export var duration: float				# duration of the hit, will block inputs
@export var startup_time: float			# time window before the skill hits
@export var expiring_window: float		# time window after which the skill resets
@export var force: HitForce
@export var effect: HitEffect
@export var damage: float

func _init(
		p_type = HitType.MEDIUM,
		p_duration = 0.0,
		p_startup_time = 0.0,
		p_expiring_window = 0.0,
		p_force = HitForce.NORMAL,
		p_effect = HitEffect.NONE,
		p_damage = 0.0) -> void:
	type = p_type
	duration = p_duration
	startup_time = p_startup_time
	expiring_window = p_expiring_window
	force = p_force
	effect = p_effect
	damage = p_damage
