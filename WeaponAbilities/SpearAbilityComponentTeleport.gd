extends Node3D
class_name SpearTeleport

func _ready() -> void:
	AbilitySignalBus.connect("teleport_to_spear", _teleport)
	
func _teleport(player : Player, _spear: Spear) -> void:
	## Teleport skill
	if _spear.state == _spear.STATE.LANDED:
		var tween = create_tween()
		player.mesh.look_at(_spear.global_position, Vector3.UP)
		tween.tween_property(player,"global_position", _spear.global_position, 0.1)
		tween.tween_callback(_spear.recall)
	print("hello")
