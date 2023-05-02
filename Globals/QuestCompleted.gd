extends Control
class_name QuestCompleted

@onready var quest_completed: Label = $Completed/questCompleted
@onready var completed: Label = $Completed
@export var on_screen_delay : float = 2.0
@export var trans_delay : float = 1.0
@onready var quest_complete_sound: AudioStreamPlayer = $questCompleteSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quest_complete_sound.play()
	SignalBus.connect("quest_completed", quest_complete)
	
	get_tree().create_timer(10).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,1),trans_delay+1).set_delay(on_screen_delay -1).set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "modulate", Color(1,1,1,0),trans_delay).set_delay(on_screen_delay)


func quest_complete(completed_quest)-> void:
	quest_completed.text = completed_quest
	
