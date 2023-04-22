extends Node3D
class_name HealthComponent

@export var health := 100.0 
@export var max_health := 300

func hurt(damage) -> void:
	health -= damage

func heal(healing) -> void:
	health += healing
