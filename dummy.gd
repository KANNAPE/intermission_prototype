extends CharacterBody2D

@export var hitstop_duration := .1

# Hit variables
@export var hit_scale: Vector2
@export var hit_color: Color

# Defaults
var default_scale: Vector2
var default_color: Color

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var hitstop_timer := 0.0

@onready var sprite: Sprite2D = %Visual


func _ready() -> void:
	default_scale = sprite.get_scale()
	default_color = sprite.get_modulate()


func _physics_process(delta: float) -> void:
	if hitstop_timer > 0.0:
		hitstop_timer -= delta
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0.0, 1500.0 * delta)
		
	move_and_slide()


func take_hit(damage: float, attack_direction: float, knockback_force: float = 400.0) -> void:
	# hitstop
	hitstop_timer = hitstop_duration
	
	# computing knockback
	velocity.x = attack_direction * knockback_force
	velocity.y = -150.0
	
	sprite.scale = hit_scale
	sprite.modulate = hit_color
	
	var tween = create_tween()
	tween.tween_property(sprite, "scale", default_scale, 0.2).set_trans(Tween.TRANS_BOUNCE)
	tween.parallel().tween_property(sprite, "modulate", default_color, 0.2)
	
	print("dummy took %d damage!", damage)
