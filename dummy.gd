extends CharacterBody2D

@export var hitstop_duration := .1

# Hit variables
@export var hit_scale: Vector2
@export var hit_color: Color

# Knockback variables
@export var staggering_force: float
@export var blowback_force: float

# Defaults
var default_scale: Vector2
var default_color: Color

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var hitstop_timer := 0.0
var last_lateral_velocity := 0.0

var tween: Tween

@onready var sprite: Sprite2D = %Visual


func _ready() -> void:
	default_scale = sprite.get_scale()
	default_color = sprite.get_modulate()


func _physics_process(delta: float) -> void:
	if hitstop_timer > 0.0:
		hitstop_timer -= delta
		return
	
	# Applying downward gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Adding friction when grounded
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0.0, 1500.0 * delta)
	else:
		# Storing lateral velocity prior to move_and_slide
		last_lateral_velocity = velocity.x
	
	move_and_slide()
	
	# Applying wall bounce if the dummy is blowbacked
	var wall_collision := get_last_slide_collision()
	if velocity.y < -20.0 and not wall_collision == null:
		# And we don't want our dummy to bounce against the player
		if not wall_collision.get_collider() is Player:
			velocity.x = -last_lateral_velocity
			velocity.y = -50.0 # small bouncing upwards


func take_hit(damage: float, force: BaseHit.HitForce, lateral_direction: float) -> void:
	# Hitstop
	hitstop_timer = hitstop_duration
	
	# Computing hit force
	if force == BaseHit.HitForce.NORMAL:
		apply_staggering(lateral_direction)
	elif force == BaseHit.HitForce.STRONG:
		apply_blowback(lateral_direction)
	
	sprite.scale = hit_scale
	sprite.modulate = hit_color
	
	# Stopping previous animations
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(sprite, "scale", default_scale, 0.2).set_trans(Tween.TRANS_BOUNCE)
	tween.parallel().tween_property(sprite, "modulate", default_color, 0.2)
	
	print("dummy took %d damage!", damage)


func apply_staggering(direction: float) -> void:
	velocity.x = staggering_force * direction
	velocity.y = -20.0


func apply_blowback(direction: float) -> void:
	velocity.x = blowback_force * direction
	velocity.y = -150.0
