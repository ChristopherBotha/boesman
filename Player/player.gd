extends CharacterBody3D
class_name Player

@export var healthComp : HealthComponent

@onready var camera_orbit: Node3D = $CameraOrbit

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var h_rot = $CameraOrbit/h.global_transform.basis.get_euler().y
	
	if camera_orbit.camrot_h != 0:
		$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, h_rot, delta * 5)
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
#	if sprinting:
#		SPEED **=2
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	velocity = velocity.rotated(Vector3.UP, $Mesh.rotation.y)
	move_and_slide()
