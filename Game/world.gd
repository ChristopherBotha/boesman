extends Node3D

@export_file("*.tscn") var ocean 
@export var resource : Resource
@export_dir var levels : String
@onready var fps: Label = $Fps

var ocean_

func _ready() -> void:
	SignalBus.connect("playerLocation",player_loc)
	spawn_level()
	spawn_ocean()
	
func spawn_level():
	var level = resource.all_resources_dict["test_level"].instantiate()
	$Level.add_child(level)

func _physics_process(delta: float) -> void:
	fps.text = str(Engine.get_frames_per_second())
	
	
func spawn_ocean():
	var _ocean = load(ocean).instantiate()
	self.add_child(_ocean)
	ocean_ = _ocean
	
func player_loc(val):
	ocean_.position = Vector3(val.position.x,0.0, val.position.z)
