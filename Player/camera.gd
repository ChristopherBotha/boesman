extends Camera3D

@export var setup : CameraDataComponent
@export var target : Player

func _ready()-> void:
	if setup.target_offset == Vector3.ZERO:
		setup.target_offset = self.transform.origin - target.transform.origin - setup.anchor_offset
	 
