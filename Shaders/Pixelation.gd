extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("pixelate", on_off)


func on_off():
	if visible == true: visible = false
	else : visible = true
