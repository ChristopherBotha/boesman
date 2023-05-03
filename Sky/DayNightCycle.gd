extends Node3D

@onready var directional_light_3d: DirectionalLight3D = $DirectionalLight3D
@onready var world_environment: WorldEnvironment = $WorldEnvironment
@export_range(0,240) var timeRate : float 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	var tween = get_tree().create_tween().set_loops().set_ease(Tween.EASE_OUT).bind_node(self)
	tween.tween_property(directional_light_3d, "rotation_degrees", Vector3(360,0,0),timeRate)
	tween.tween_callback(increase_day)
	
func _physics_process(delta: float) -> void:
	
	
	
	if directional_light_3d.rotation_degrees >= Vector3(0,0,0) and directional_light_3d.rotation_degrees <= Vector3(155,0,0) :
		directional_light_3d.light_energy = move_toward(directional_light_3d.light_energy,0.0,0.5)
	else:
		directional_light_3d.light_energy = move_toward(directional_light_3d.light_energy,1.0,0.5)

func increase_day():
	directional_light_3d.rotation_degrees = Vector3.ZERO
	QuestSignalBus.emit_signal("increase_day")
	
	

