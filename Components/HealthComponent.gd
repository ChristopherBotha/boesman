extends Node3D
class_name HealthComponent

@export var max_health : float

@export var current_health : float :
	set(new_value):
		current_health = new_value
		if owner and owner.is_in_group("Player"):
			SignalBus.emit_signal("healthUpdated",current_health)
		
func hurt(damage) -> void:
	current_health -= damage
	if current_health <= 0.0:
		owner.died = true
		owner.activate_ragdoll()
		
func heal(healing) -> void:
	current_health += healing
	
func _ready()->void:
	current_health = max_health
	


