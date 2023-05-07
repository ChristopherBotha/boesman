@tool
extends Control
class_name QuestTrackerComponent

@onready var tree: Tree = $Tree


var _quest_channel := QuestChannel
var _quest_tracker := QuestTracker

@onready var side_quest: CheckButton = $SideQuest/CheckButton 

@onready var quest_name: TextEdit = $QuestName/Quest_name 
@onready var quest_desc: TextEdit = $QuestDesc/Quest_desc
@onready var v_box_container: VBoxContainer = $QuestObjectives/VBoxContainer

@onready var save_file: Button = $Save_File
@onready var save_quest: Button = $Save_quest

#func _init() -> void:
#	tree.request_ready()

func _ready()-> void:
#	print(_quest_tracker.quests.keys()[1][0])
#	print(_quest_tracker.quests_data)
	pass

func _on_save_quest_pressed() -> void:
	var _objectives : PackedStringArray = []
	var box_kids = v_box_container.get_children()
	
	for i in box_kids:
		if i.text != "":
			_objectives.append(i.text)
			
	var quest = Quest.new(quest_name.text,quest_desc.text,_objectives)
	quest.add_quest(quest.quest_name,quest.quest_desc,quest.objectives)
	_quest_channel.emit_signal("add_new_quest")

func _process(delta: float) -> void:
	if quest_name.text == "" and quest_desc.text == "":
		save_file.disabled = true
		save_quest.disabled = true
	else:
		save_file.disabled = false
		save_quest.disabled = false
		
func _on_save_file_pressed() -> void:
	_quest_tracker.save()

func _on_load_data_pressed() -> void:
	_quest_channel.emit_signal("add_new_quest")
