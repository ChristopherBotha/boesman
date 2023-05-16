extends Control
class_name PauseMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("pause_menu", pausing)

func pausing():
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color(1,1,1,1),0.3)

func _on_resume_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var tween = create_tween()
	await tween.tween_property(self,"modulate",Color(1,1,1,0),0.3).finished
	get_tree().paused = false

func _on_pixelate_pressed() -> void:
	SignalBus.emit_signal("pixelate")


func _on_quit_pressed() -> void:
	get_tree().quit()
