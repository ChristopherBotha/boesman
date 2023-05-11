extends Node3D

@export var resource : Resource
@export_dir var levels : String
@onready var fps: Label = $Fps

func _ready() -> void:
	spawn_level()

func spawn_level():
	var level = resource.all_resources_dict["test_level"].instantiate()
	$Level.add_child(level)

func _physics_process(delta: float) -> void:
	fps.text = str(Engine.get_frames_per_second())

