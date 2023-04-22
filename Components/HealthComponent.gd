extends Node3D
class_name HealthComponent

@export var current_health := 100.0:
	set(new_value):
		current_health = new_value
		SignalBus.emit_signal("healthupdated")

@export var max_health := 300

func hurt(damage) -> void:
	current_health -= damage

func heal(healing) -> void:
	current_health += healing
