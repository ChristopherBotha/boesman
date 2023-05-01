extends TextureProgressBar
class_name ProgressBarComponent

func _ready() -> void:
	SignalBus.connect("healthUpdated",_updatehealth)
	updateHealthBar()

func _updatehealth(val)-> void:
	value = val
	
func updateHealthBar()-> void:
	max_value = owner.healthComp.max_health
	value = max_value
