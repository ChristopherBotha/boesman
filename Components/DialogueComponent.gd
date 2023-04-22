extends Node3D
class_name DialogueComponent

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "Start"

func action() -> void:
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
