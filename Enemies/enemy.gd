extends CharacterBody3D

@export var detectComponent : DectectionComponent
@export var healthComp : HealthComponent

@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")
@onready var playback = $Enemy/AnimationTree.get("parameters/playback")
@onready var animation_tree: AnimationTree = $Enemy/AnimationTree

var current_rotation : Quaternion 
var vel := Vector3.ZERO

var reached : bool = false

func _ready() -> void:
	print(healthComp.current_health)
	SignalBus.connect("playerLocation", set_target_loc)
	
func set_target_loc(val: Vector3):
	navigation_agent.target_position = val
	if reached == false:
		look_at(val,Vector3.UP)
	
func _physics_process(delta: float) -> void:
	var rot : Quaternion = animation_tree.get_root_motion_rotation()
	
	if not is_on_floor():
		velocity.y -= 20 * delta
	
	if is_on_floor() and reached == false:
		current_rotation = get_quaternion()
		
		var next_path_position: Vector3 = navigation_agent.get_next_path_position()
		var current_agent_position: Vector3 = global_position
		var new_velocity = (next_path_position - current_agent_position).normalized()
		
		#interpolates velocity for animation blending
		vel = vel.lerp(new_velocity,0.05)

	animation_tree.set("parameters/Move/blend_position", vel.length())
	
	if is_on_floor():
		velocity = rot * current_rotation * animation_tree.get_root_motion_position() / delta * 0.5
		velocity = velocity.rotated(Vector3.UP, $Enemy/Armature.rotation.y)

	move_and_slide()


func _on_navigation_agent_3d_target_reached() -> void:
	reached = true
	vel = vel.lerp(Vector3.ZERO,0.05)
