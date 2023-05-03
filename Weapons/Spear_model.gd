extends Node3D
@onready var skeleton_3d: Skeleton3D = $Cube/Armature/Skeleton3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skeleton_3d.physical_bones_start_simulation()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
