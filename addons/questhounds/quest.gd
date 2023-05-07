@tool
extends Node
class_name Quest

#@onready var resource : Resource = preload()
@onready var _quest_channel := QuestChannel
@onready var _quest_tracker := QuestTracker

var quest_name: String
var quest_desc: String
var objectives: PackedStringArray

var is_complete: bool = false
enum quest_state {PENDING, ACTIVE, COMPLETE}

func _init(quest_name: String, quest_desc: String, objectives: PackedStringArray):
	self.quest_name = quest_name
	self.quest_desc = quest_desc
	self.objectives = objectives

func complete():
	is_complete = true
	# Handle quest completion logic here

# Initialize a dictionary to hold all quests_data
var quests_data = QuestTracker.quests_data

# Add a new quest
func add_quest(quest_name: String, quest_desc: String, objectives: PackedStringArray):
	## Each quest must have a unique name
	## creates new quest
	var quest = {"quest_name" : quest_name, "quest_desc":quest_desc,"objectives":objectives}
	quests_data[quest_name] = quest
	QuestTracker.quest_data_to_quests()
#	QuestTracker.save()
	
# Check if a quest is complete
func is_quest_complete(quest_name: String):
	var quest = quests_data[quest_name]
	if quest:
		return quest.is_complete
	return false

# Mark a quest objective as complete
func complete_objective(quest_name: String, objective_index: int):
	var quest = quests_data[quest_name]
	if quest:
		quest.objectives[objective_index] = true	
		# Handle objective completion logic here

# Check if a quest objective is complete
func is_objective_complete(quest_name: String, objective_index: int):
	var quest = quests_data[quest_name]
	if quest:
		return quest.objectives[objective_index]
	return false

# Complete a quest
func complete_quest(quest_name: String):
	var quest = quests_data[quest_name]
	if quest:
		quest.complete()
		# Handle quest completion logic here

func _ready() -> void:
	_quest_channel.connect("quest_completed", complete_quest)
