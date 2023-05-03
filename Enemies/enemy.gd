extends CharacterBody3D

@export var detectComponent : DectectionComponent
@export var healthComp : HealthComponent
@onready var skeleton_3d: Skeleton3D = $Enemy/Armature/Skeleton3D

@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")
@onready var playback = $Enemy/AnimationTree.get("parameters/playback")
@onready var animation_tree: AnimationTree = $Enemy/AnimationTree

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var died := false

var current_rotation : Quaternion 
var vel := Vector3.ZERO

var reached : bool = false

func _ready() -> void:
	SignalBus.connect("playerLocation", set_target_loc)
	
func set_target_loc(val: Vector3):
	navigation_agent.target_position = val
	if reached == false:
		look_at(val,Vector3.UP)
	
func _physics_process(delta: float) -> void:
	var rot : Quaternion = animation_tree.get_root_motion_rotation()
	
	if Engine.time_scale < 1 and not is_on_floor(): 
		velocity.y -= gravity * 20 * delta
	elif Engine.time_scale == 1 and not is_on_floor():
		velocity.y -= gravity * delta
		
	
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

func activate_ragdoll()-> void:
	skeleton_3d.physical_bones_start_simulation()

