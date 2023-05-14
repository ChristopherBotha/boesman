extends Node

# Keeps track of items fopr quests
var has_cell_1_key : bool = false
var has_bow : bool = false
var has_spear : bool = false
var golden_apple : bool = false
var escaped_prison : bool = false
var has_reached_level_10 : bool = false

var days_passed : int = 0

var skeloton_keys : int:
	set(new_value):
		skeloton_keys = new_value 

var skeloton_golden_key : int:
	set(new_value):
		skeloton_golden_key = new_value
		
		
# keep track of current quest
var current_active_quest : String
var current_active_quest_desc : String
var completed_quests = {}

# since there can be multiple quests active at a time
var current_active_quests = {}

# checks if quest is active
var is_quest_active := false

#func _ready()-> void:
#	QuestSignalBus.connect("new_quest",get_new_quest)
#	QuestSignalBus.connect("quest_completed",get_completed_quest)
#	QuestSignalBus.connect("increase_day", increase_day)
	
#func get_new_quest(q_name,q_desc,q_reward):
#	var _quest = quest_.instantiate()
#	_quest.quest_description = q_desc
#	current_active_quest = q_name
#	_quest.quest_name = q_name
#
#	get_tree().get_root().add_child(_quest)
#
#func get_completed_quest(q_name)-> void:
#	var _complete = complete_.instantiate()
#	_complete.quest_name = q_name
#
#	get_tree().get_root().add_child(_complete)

func increase_day()-> void:
	days_passed += 1
	print(days_passed)
