extends RigidBody3D
class_name Arrow


@export var speed = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	top_level = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if top_level == true:
		apply_impulse(-transform.basis.z, -transform.basis.z * speed * delta)

	if get_colliding_bodies().size() > 0:
		for i in get_colliding_bodies():
			if i.is_in_group("Enemies"):
				
				top_level = false
#				freeze = true
				reparent(i,true)
				
				
