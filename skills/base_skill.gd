class_name BaseSkill
extends Resource

enum SkillType {
	PRIMARY,
	SECONDARY,
	SPECIAL,
}

@export var type: SkillType
@export var priority: int
@export var hits: Array[BaseHit]

func _init(p_type = SkillType.PRIMARY, p_priority = 0) -> void:
	type = p_type
	priority = p_priority
