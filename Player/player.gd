extends CharacterBody3D
class_name Player

@onready var animation_tree: AnimationTree = $Mesh/AnimationTree

@export var healthComp : HealthComponent
@export var stats : StatsComponent
@export var actions : StateComponent

@onready var camera_3d: Camera3D = $CameraOrbit/h/v/SpringArm3D/Camera3D
@onready var camera_orbit: Node3D = $CameraOrbit

var JUMP_VELOCITY := 4.5
var current_rotation : Quaternion 


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
 
func _ready()-> void:
	pass
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	var rot : Quaternion = animation_tree.get_root_motion_rotation()
	var h_rot = $CameraOrbit/h.global_transform.basis.get_euler().y
	
	if camera_orbit.camrot_h != 0 and actions.aiming == true:
		$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, h_rot, delta * 5)
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if input_dir:
		$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, h_rot, delta * 5)
		
	if is_on_floor() and Input.is_action_just_pressed("sprint"):
		if actions.sprinting == false:
			actions.sprinting = true
			stats.speed = 10
		elif actions.sprinting == true:
			actions.sprinting = false 
			stats.speed = 2
	
	if Input.is_action_pressed("aim"):
		actions.aiming = true
		camera_3d.fov = 25
	elif Input.is_action_just_released("aim"):
		actions.aiming = false
		camera_3d.fov = 75
	
	if direction:
		velocity.x = direction.x * stats.speed
		velocity.z = direction.z * stats.speed
	else:
		velocity.x = move_toward(velocity.x, 0, stats.speed)
		velocity.z = move_toward(velocity.z, 0, stats.speed)
	
	velocity = velocity.rotated(Vector3.UP, $Mesh.rotation.y)
	move_and_slide()
