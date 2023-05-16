extends Node3D

@onready var _sun: DirectionalLight3D = $SunMoon/Sun
@onready var _moon: DirectionalLight3D = $SunMoon/Moon
@onready var sun_moon: Node3D = $SunMoon

@onready var world_environment: WorldEnvironment = $WorldEnvironment
@export_range(0,240) var timeRate : float 

var skyMaterial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("start_rain", start_rain)
	SignalBus.connect("end_rain", end_rain)
	
	skyMaterial = world_environment.environment.sky.get_material()
	day_night()
	
func _physics_process(delta: float) -> void:
#	if _sun.rotation_degrees >= Vector3(0,0,0) and _sun.rotation_degrees <= Vector3(155,0,0) :
#		_sun.light_energy = move_toward(_sun.light_energy,0.0,0.5)
#	else:
#		_sun.light_energy = move_toward(_sun.light_energy,1.0,0.5)
	pass

func day_night()-> void:
	var tween = get_tree().create_tween().set_parallel(true).set_loops().set_ease(Tween.EASE_OUT).bind_node(self)
	tween.tween_property(_sun, "rotation_degrees", Vector3(360,0,0),timeRate)
	tween.tween_property(skyMaterial,"shader_parameter/_time_offset",1000,timeRate)
#	tween.tween_property(world_environment,"shader_parameter/cloud_coverage",1,5)
	tween.chain().tween_callback(increase_day)

func increase_day():
	skyMaterial.set_shader_parameter("time_offset",0)
	_sun.rotation_degrees = Vector3.ZERO

func start_rain()-> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).bind_node(self)
	tween.tween_property(skyMaterial,"shader_parameter/cloud_coverage",1,timeRate / 2)
	
func end_rain()-> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).bind_node(self)
	tween.tween_property(skyMaterial,"shader_parameter/cloud_coverage",randf_range(0.10,0.25),timeRate / 2)
