extends Control
class_name QuestStart

var quest_name : String = "Hi"
var quest_description : String = "Daar"

@export var on_screen_delay : float = 2.0
@export var trans_delay : float = 1.0

@onready var quest_name_label: Label = $questName
@onready var quest_description_label: Label = $questName/questDescription
@onready var quest_complete_sound: AudioStreamPlayer = $questsound

func _ready() -> void:
	quest_name_label.text = quest_name
	quest_description_label.text = quest_description	
	quest_complete_sound.play()
	
	Engine.time_scale = 0.1
	
	var tween = get_tree().get_root().create_tween().bind_node(self).set_speed_scale(1.0/ Engine.time_scale)
	
	tween.tween_property(self, "modulate", Color(1,1,1,1),trans_delay+1).set_delay(on_screen_delay -1).set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "modulate", Color(1,1,1,0),trans_delay).set_delay(on_screen_delay)
	tween.tween_property(Engine,"time_scale",1,0.5).set_delay(0.01)
	tween.tween_callback(queue_free)

