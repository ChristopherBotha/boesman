extends Area3D
class_name WeakSpotComponent

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@export var detection_size := 2.0

func _ready() -> void:
	collision_shape_3d.shape.size = collision_shape_3d.shape.size * detection_size

