extends Area3D
class_name DectectionComponent

@export var detection_size := 2
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D


func _ready() -> void:
	collision_shape_3d.shape.size = collision_shape_3d.shape.size * detection_size
