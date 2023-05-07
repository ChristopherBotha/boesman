@tool
extends Node
class_name QuestData

@onready var _quest_channel := QuestChannel
@onready var _quest_tracker := QuestTracker

var quest_name: String
var quest_desc: String
var objectives: PackedStringArray

func _init(quest_name: String, quest_desc: String, objectives: PackedStringArray):
	self.quest_name = quest_name
	self.quest_desc = quest_desc
	self.objectives = objectives
