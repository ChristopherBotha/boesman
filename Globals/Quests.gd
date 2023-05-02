extends Control
class_name Quests

var quest_name : String
var quest_description : String

@onready var quest_name_label: Label = $questName
@onready var quest_description_label: RichTextLabel = $questName/questDescription


func _ready() -> void:
	quest_name_label.text = quest_name
	quest_description_label.text = quest_description
	
