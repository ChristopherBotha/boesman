extends Node3D
class_name EntityNavigationComponent

@export var nav_agent: NavigationAgent3D
var next_location := Vector3.ZERO
var new_velocity := Vector3.ZERO
var current_location := Vector3.ZERO


func update_target_location(target_location):
	nav_agent.target_position = target_location
	
func _on_navigation_agent_3d_navigation_finished() -> void:
	owner.velocity = Vector3.ZERO

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	owner.velocity = owner.velocity.move_toward(safe_velocity,0.25)

func _on_navigation_agent_3d_target_reached() -> void:
#	owner.Idle = true
	owner.velocity = Vector3.ZERO
	
func idle(delta):
	owner.velocity = Vector3.ZERO

func persue(delta)-> void:
	if nav_agent.is_target_reachable() :
		current_location = global_position
		next_location = nav_agent.get_next_path_position()
		new_velocity = (next_location - current_location).normalized() * 5
		nav_agent.set_velocity(new_velocity)
	
	owner.move_and_slide()
