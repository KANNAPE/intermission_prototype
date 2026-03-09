extends CharacterBody2D

@export var speed := 100.0
@export var gravity_factor := 600.0
@export var jump_force := 200.0
@export var jumps := 2

@export_category("Skills")
@export var skills: Array[BaseSkill]

# Movement-related variables
var lateral_direction := 0.0
var wants_to_jump := false
var target_velocity := Vector2.ZERO
var jump_count := 0

# Skill-related variables
var current_skill: BaseSkill
var skill_hit_index := 0
var skill_exec_duration := 0.0
var skill_expiring_window_timer := 0.0 

@onready var hitboxes: Node2D = %Hitboxes
@onready var text_jump_count: Label = %JumpCount
@onready var text_skill_duration: Label = %SkillDuration
@onready var text_skill_expiring_window: Label = %SkillExpiringWindow
@onready var visual: Sprite2D = %Visual


func _process(_delta: float) -> void:
	# process movement, for now not allowed when moving
	if not skill_exec_duration > 0.0:
		process_movement()
	
	# process jumping
	text_jump_count.set_text("jump count: " + str(jump_count))
	
	if Input.is_action_just_pressed("jump") and not jump_count == jumps:
			wants_to_jump = true
	
	# process skills
	process_skills(_delta)


func _physics_process(delta: float) -> void:
	# Movement
	target_velocity.x = lateral_direction * speed
	
	# Jumping
	if wants_to_jump:
		target_velocity.y = -jump_force
		jump_count += 1
	
	# Gravity
	if not is_on_floor():
		target_velocity.y = target_velocity.y + (gravity_factor * delta)
	elif not wants_to_jump:
		target_velocity.y = 0
		jump_count = 0
	
	# Input consumption
	lateral_direction = 0.0
	wants_to_jump = false
	
	velocity = target_velocity
	move_and_slide()


func process_movement() -> void:
	if Input.is_action_pressed("move_left"):
		lateral_direction = -1.0
	if Input.is_action_pressed("move_right"):
		lateral_direction = 1.0
	
	if not is_zero_approx(lateral_direction):
		visual.set_scale(Vector2(4.0 * lateral_direction, 4.0))
		
		for hitbox: Area2D in hitboxes.get_children():
			hitbox.position.x = 36.0 * lateral_direction


func process_skills(delta: float) -> void:
	text_skill_duration.set_text("Skill duration: " + str(skill_exec_duration))
	text_skill_expiring_window.set_text("Skill expiring window: " + str(skill_expiring_window_timer))
	
	if not skill_exec_duration <= 0.0:
		skill_exec_duration -= delta
		# We reached the end of the execution duration
		if skill_exec_duration <= 0.0 and not current_skill == null:
			skill_exec_duration = 0.0
			skill_expiring_window_timer = current_skill.hits[skill_hit_index].expiring_window
			if skill_expiring_window_timer <= 0.0:
				current_skill = null # security
		return
	
	if not skill_expiring_window_timer <= 0.0:
		skill_expiring_window_timer -= delta
		# We reached the end of the expiring window
		if skill_expiring_window_timer <= 0.0:
			skill_expiring_window_timer = 0.0
			current_skill = null
			return
	
	# Skill input listening
	var primary_is_triggered := Input.is_action_just_pressed("primary")
	var secondary_is_triggered := Input.is_action_just_pressed("secondary")
	
	if not primary_is_triggered and not secondary_is_triggered:
		return
	
	# If no skill are being used, we look for inputs
	if current_skill == null:
		if primary_is_triggered and secondary_is_triggered:
			print("unimplemented")
			return
		
		# We retrieve the corresponding skill
		if primary_is_triggered:
			current_skill = get_skill(BaseSkill.SkillType.PRIMARY)
			print("primary")
		elif secondary_is_triggered:
			current_skill = get_skill(BaseSkill.SkillType.SECONDARY)
			print("secondary")
		
		if current_skill == null:
			printerr("there are no skills that correspond the input!")
			return
		
		skill_hit_index = 0
		
		var current_hit := current_skill.hits[skill_hit_index]
		skill_exec_duration = current_hit.duration + current_hit.startup_time
		
		var hitbox := hitboxes.get_child(current_hit.type) as Area2D
		if hitbox == null:
			printerr("request hitbox doesn't exist!")
		else:
			display_skill_hitbox(hitbox, current_hit.duration, current_hit.startup_time)
		
	# If a skill is being used, and the expiring window is still open
	elif (primary_is_triggered and current_skill.type == BaseSkill.SkillType.PRIMARY
			or secondary_is_triggered and current_skill.type == BaseSkill.SkillType.SECONDARY):
		if skill_hit_index == len(current_skill.hits) - 1:
			return
			
		skill_hit_index += 1
		
		var current_hit := current_skill.hits[skill_hit_index]
		skill_exec_duration = current_hit.duration
		
		var hitbox := hitboxes.get_child(current_hit.type) as Area2D
		if hitbox == null:
			printerr("request hitbox doesn't exist!")
		else:
			display_skill_hitbox(hitbox, current_hit.duration, current_hit.startup_time)


func get_skill(skill_type: BaseSkill.SkillType) -> BaseSkill:
	var corresponding_skill: BaseSkill = null
	
	for skill in skills:
		if skill.type == skill_type:
			if corresponding_skill == null:
				corresponding_skill = skill
			elif corresponding_skill.priority < skill.priority:
				corresponding_skill = skill
	
	if corresponding_skill == null:
		printerr("There is no matching skill for type: %s!", str(skill_type))
	
	return corresponding_skill


func display_skill_hitbox(hitbox: Area2D, time: float, start_up_time: float = 0.0) -> void:
	hitbox.set_visible(true)
	if not start_up_time == 0.0:
		hitbox.modulate.a = 90.0/255.0
		await get_tree().create_timer(start_up_time).timeout
		hitbox.modulate.a = 1.0
	await get_tree().create_timer(time).timeout
	hitbox.set_visible(false)
