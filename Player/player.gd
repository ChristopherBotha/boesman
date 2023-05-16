extends CharacterBody3D
class_name Player

@export var arrow : PackedScene
@export var spear : CharacterBody3D

@onready var animation_tree: AnimationTree = $Mesh/AnimationTree
@onready var playback = $Mesh/AnimationTree.get("parameters/playback")
@onready var crosshair: TextureRect = $crosshair

@onready var aim_cast: RayCast3D = $CameraOrbit/h/v/SpringArm3D/Camera3D/AimCast
@export var healthComp : HealthComponent
@export var stats : StatsComponent
@export var actions : StateComponent
@export var footLeft : FootComponent
@export var footRight : FootComponent
@onready var mesh: Node3D = $Mesh

@onready var camera_3d: Camera3D = $CameraOrbit/h/v/SpringArm3D/Camera3D
@onready var camera_orbit: Node3D = $CameraOrbit

@onready var skeleton_3d: Skeleton3D = $Mesh/Armature/Skeleton3D

@onready var turn_left 
@onready var turn_right 

var dashing := false
var current_rotation : Quaternion 
var current_dir := Vector3.ZERO
var dir := Vector3.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var prev_cam_rot = 0.0

func _ready()-> void:
	SignalBus.connect("catch_spear", catch_spear)
	animation_tree.set("parameters/Transition/current_state", "Walk")
	
func _physics_process(delta: float) -> void:

	# Add the gravity.
	skeleton_3d.get_bone_pose(6)
	SignalBus.emit_signal("playerLocation", self)
	_handle_input(delta)
	_button_inputs(delta)
	move_and_slide()

func _handle_input(delta)-> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var rot : Quaternion = animation_tree.get_root_motion_rotation()
	var h_rot = $CameraOrbit/h.global_transform.basis.get_euler().y
	var cam_rot = $CameraOrbit/h.global_rotation_degrees.y

	var input_dir = Vector3(Input.get_action_strength("left") - Input.get_action_strength("right"),0,
			Input.get_action_strength("forward") - Input.get_action_strength("backward")).normalized()
	
	dir = dir.lerp(input_dir, 0.1)
	current_dir = current_dir.lerp(input_dir.rotated(Vector3.UP, h_rot),0.05)

	animation_tree.set("parameters/Run/blend_position", current_dir.length())
	animation_tree.set("parameters/Walk/blend_position", current_dir.length())
	animation_tree.set("parameters/AimMove/blend_position", Vector2(dir.x, dir.z))
	
	
	if input_dir and actions.aiming == false:
		current_rotation = get_quaternion()
		$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, atan2(current_dir.x, current_dir.z), delta * 5)
	
	if camera_orbit.camrot_h != 0 and actions.aiming == true:
		current_rotation = get_quaternion()
		$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, h_rot, delta * 5)
		
	if is_on_floor():
		## NOTE: The 0.5 prevents foot sliding form happening
		velocity = rot * current_rotation * animation_tree.get_root_motion_position() / delta 
		velocity = -velocity.rotated(Vector3.UP, $Mesh.rotation.y)

func _button_inputs(_delta)->void:
	
	if is_on_floor() and Input.is_action_pressed("sprint") and actions.aiming == false:
		if actions.sprinting == false:
			$SprintTimer.start()
			animation_tree.set("parameters/WR/transition_request", "Sprint")
			actions.sprinting = true
			var tween = get_tree().create_tween()
			tween.parallel().tween_property(camera_3d, "fov", 85, 0.5)
			
	if Input.is_action_just_released("sprint") and actions.sprinting == true and actions.aiming == false:
			$SprintTimer.stop()
			animation_tree.set("parameters/WR/transition_request", "Walk")
			actions.sprinting = false 
			var tween = get_tree().create_tween()
			tween.parallel().tween_property(animation_tree, "parameters/Lean/add_amount", 0, 0.05)
			tween.parallel().tween_property(animation_tree, "parameters/Dash/scale", 1, 0.05)
			tween.parallel().tween_property(animation_tree, "parameters/WalkScale/scale", 1, 0.05)
			tween.parallel().tween_property(camera_3d, "fov", 75, 0.3)
			
	if camera_orbit.cam_v == deg_to_rad(-90) :
		animation_tree.set("parameters/OneShot/request", "Fire")
	elif camera_orbit.cam_v == deg_to_rad(90):
		animation_tree.set("parameters/OneShot/active", true)

	if Input.is_action_just_pressed("shoot") and stats.ammo_arrow > 0:
#		var ar = arrow.instantiate()
#		$Mesh/Nozzle.add_child(ar)
#		ar.global_position = $Mesh/Nozzle.global_position
#		stats.ammo_arrow -= 1
		if spear.state == spear.STATE.HELD:
			print("throw spear")
			animation_tree.set("parameters/ThrowSpear/request", true)
#			throw_spear()
			
	if Input.is_action_just_pressed("recall"):
		spear.recall()

		
	if Input.is_action_pressed("aim"):
		animation_tree.set("parameters/Aiming/transition_request", "Aim")
		actions.aiming = true
		camera_3d.fov = 25
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(camera_3d, "fov", 25, 0.1)
		tween.parallel().tween_property(crosshair, "modulate", Color(1,1,1,1), 0.5)

	elif Input.is_action_just_released("aim"):
		animation_tree.set("parameters/Aiming/transition_request", "not_Aim")
		actions.aiming = false
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(camera_3d, "fov", 75, 0.1)
		tween.parallel().tween_property(crosshair, "modulate", Color(1,1,1,0),0.5)

		if aim_cast.is_colliding():
			pass

	if Input.is_action_just_pressed("equip"):
		animation_tree.set("parameters/EquipBow/active", true)
	
func _on_sprint_timer_timeout() -> void:
	dashing = true
	
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(animation_tree, "parameters/Lean/add_amount", 1, 0.1)
	tween.parallel().tween_property(animation_tree, "parameters/Dash/scale", 3, 0.1)
	tween.parallel().tween_property(animation_tree, "parameters/WalkScale/scale", 3, 0.1)
	tween.parallel().tween_property(camera_3d, "fov", 100, 0.5)

func _on_axe_returned():
#	state_machine.travel("Catch")
	pass
	
func throw_spear()-> void:
	SignalBus.emit_signal("throw_spear")
	
func catch_spear()-> void:
#	animation_tree.set("parameters/CatchSpear/request", true)
	pass

func spear_returned()-> void:
	SignalBus.emit_signal("spear_returned")

