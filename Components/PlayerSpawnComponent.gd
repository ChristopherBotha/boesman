extends Node3D
class_name PlayerSpawnComponent

@export_file("*.tscn") var player : String

func _ready()-> void:
	## Spawn Player
	var player1 = load(player).instantiate()
	add_child(player1)
	player1.global_position = global_position

