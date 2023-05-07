@tool
extends Tree
class_name QuestTree

@onready var _quest_channel := QuestChannel
@onready var _quest_tracker := QuestTracker
	
func _ready() -> void:
	_quest_channel.connect("add_new_quest", _new_quest)
	_new_quest()

# Called when the node enters the scene tree for the first time.
func _new_quest() -> void:
	clear()
	var root = create_item()
	root.set_selectable(0, false)
	hide_root = true
	
	var quests = QuestTracker.quests_data
	
	for i in quests:
		var quest_name_item = create_item(root)
		quest_name_item.set_selectable(0, false)
		quest_name_item.set_text(0,str(quests[i].quest_name))
		
		for j in quests[i].objectives.size():
			var quest_objective_item = create_item(quest_name_item)
			quest_objective_item.set_custom_font_size(0,12)
			quest_objective_item.set_selectable(0, false)
			quest_objective_item.set_text(0,str(quests[i].objectives[j]))
			
