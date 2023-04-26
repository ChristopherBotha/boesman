extends Node3D
class_name HealthComponent

@export var healthBar : ProgressBar
@export var max_health : float

@export var current_health : float :
	set(new_value):
		current_health = new_value
		SignalBus.emit_signal("healthUpdated",current_health)

func hurt(damage) -> void:
	current_health -= damage
	
func heal(healing) -> void:
	current_health += healing

func _ready()->void:
	updateHealthBar()
	
	current_health = max_health
	SignalBus.connect("healthUpdated",_updatehealth)

func _updatehealth(val)-> void:
	healthBar.value = val
	
func updateHealthBar()-> void:
	healthBar.max_value = max_health
	healthBar.value = current_health
