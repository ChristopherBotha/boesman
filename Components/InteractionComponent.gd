extends Node3D
class_name Interaction

signal interaction

@onready var buttons_prompt: TextureRect = $buttons_prompt
@onready var interact_area_3d: Area3D = $InteractArea3D
@onready var interact_collision_shape_3d: CollisionShape3D = $InteractArea3D/InteractCollisionShape3D
@onready var interact_sound: AudioStreamPlayer = $Sounds/InteractSound


@export var interact_collision_size : Vector3 = Vector3.ZERO
@export var dialogue_component : DialogueComponent
@export var interact_label = "none"
@export var interact_type = "none"
@export var interact_value = "none"

var can_interact : bool = false 

func _ready()-> void:
	buttons_prompt.visible = false
	interact_collision_shape_3d.shape.size = interact_collision_size

func _process(delta: float) -> void:
	if can_interact == true:
		if Input.is_action_just_pressed("Interact"):
			interact_sound.play()
			buttons_prompt.visible = false
			dialogue_component.action()
			can_interact = false
			emit_signal("interaction")
	
func _on_interact_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		can_interact = true
		buttons_prompt.visible = true

func _on_interact_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		can_interact = false
		buttons_prompt.visible = false
