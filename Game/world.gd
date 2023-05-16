extends Node3D

@export var pause_menu : PauseMenu
@export_file("*.tscn") var ocean 
@export var resource : Resource
@export_dir var levels : String
@onready var fps: Label = $Fps

var ocean_
var rain : bool = false

func _init() -> void:
	self.pause_menu = pause_menu

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

func _input(event):

	if event is InputEventKey:
		match event.keycode:
			KEY_ESCAPE:
				get_tree().paused = true
				SignalBus.emit_signal("pause_menu")
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



func _on_rain_pressed() -> void:
	if rain == false : 
		rain = true 
		SignalBus.emit_signal("start_rain")
		print("Raining")
	elif rain == true : 
		rain = false
		SignalBus.emit_signal("end_rain")
		print("stopped Raining")
