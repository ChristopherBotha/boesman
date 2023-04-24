extends CharacterBody3D
class_name Player

@onready var animation_tree: AnimationTree = $Mesh/AnimationTree
@onready var playback = $Mesh/AnimationTree.get("parameters/playback")

@export var healthComp : HealthComponent
@export var stats : StatsComponent
@export var actions : StateComponent

@onready var camera_3d: Camera3D = $CameraOrbit/h/v/SpringArm3D/Camera3D
@onready var camera_orbit: Node3D = $CameraOrbit

var JUMP_VELOCITY := 4.5
var current_rotation : Quaternion 
var current_dir := Vector3.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var prev_cam_rot = 0.0

func _ready()-> void:
#	animation_tree.set("parameters/Move/blend_position", Vector2(current_dir.x,current_dir.z))
	pass
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var rot : Quaternion = animation_tree.get_root_motion_rotation()
	var h_rot = $CameraOrbit/h.global_transform.basis.get_euler().y
	
	var cam_rot = $CameraOrbit/h.global_rotation_degrees.y
	
	print(rotation)
	if cam_rot > prev_cam_rot:
		print("left")
	elif cam_rot < prev_cam_rot:
		print("right")
	
	prev_cam_rot = cam_rot
		
	if camera_orbit.camrot_h != 0 and actions.aiming == true:
		$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, h_rot, delta * 5)
	
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Vector3(Input.get_action_strength("right") - Input.get_action_strength("left"),0,
			Input.get_action_strength("forward") - Input.get_action_strength("backward"))
	
	current_dir = current_dir.lerp(input_dir.normalized(),0.05)
	
	animation_tree.set("parameters/Move/blend_position", Vector2(current_dir.x,current_dir.z))
	
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.z)).normalized()
	current_rotation = get_quaternion()
	
	if input_dir:
		$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, h_rot, delta * 5)
		
	if is_on_floor() and Input.is_action_pressed("sprint"):
		if actions.sprinting == false:
#			playback.travel("Run")
			actions.sprinting = true
			
	if Input.is_action_just_released("sprint") and actions.sprinting == true:
#			playback.travel("Move")
			actions.sprinting = false 
	
	if Input.is_action_pressed("aim"):
		actions.aiming = true
		camera_3d.fov = 25
	elif Input.is_action_just_released("aim"):
		actions.aiming = false
		camera_3d.fov = 75
	
	if Input.is_action_just_pressed("equip"):
		animation_tree.set("parameters/EquipBow/active", true)
	
	if is_on_floor():
		velocity = rot * current_rotation * animation_tree.get_root_motion_position() / delta
		velocity = -velocity.rotated(Vector3.UP, $Mesh.rotation.y)
		
	move_and_slide()
