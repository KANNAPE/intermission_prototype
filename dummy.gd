extends CharacterBody2D

@onready var sprite: Sprite2D = %Visual

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0.0, 1500.0 * delta)
		
	move_and_slide()


func take_hit(damage: float, attack_direction: float, knockback_force: float = 400.0) -> void:
	# computing knockback
	velocity.x = attack_direction * knockback_force
	velocity.y = -150.0
	
	print("knockback force: %v" % velocity)
	
	sprite.modulate = Color.WHITE
	sprite.scale = Vector2(1.3, 0.7)
	
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(0.0, 0.0, .4), 0.2)
	tween.parallel().tween_property(sprite, "scale", 4.0 * Vector2.ONE, 0.2).set_trans(Tween.TRANS_BOUNCE)
	
	print("dummy took %d damage!", damage)
