# Define a quest class
class_name Quest

var name: String
var description: String
var is_complete: bool = false
var objectives: PackedByteArray

func _init(name: String, description: String, objectives: PackedByteArray):
	self.name = name
	self.description = description
	self.objectives = objectives

func complete():
	is_complete = true
	# Handle quest completion logic here

# Initialize a dictionary to hold all quests
var quests: Dictionary = {}

# Add a new quest
func add_quest(name: String, description: String, objectives: PackedByteArray):
	var quest = Quest.new(name, description, objectives)
	quests[name] = quest

# Check if a quest is complete
func is_quest_complete(name: String):
	var quest = quests[name]
	if quest:
		return quest.is_complete
	return false

# Mark a quest objective as complete
func complete_objective(quest_name: String, objective_index: int):
	var quest = quests[quest_name]
	if quest:
		quest.objectives[objective_index] = true	
		# Handle objective completion logic here

# Check if a quest objective is complete
func is_objective_complete(quest_name: String, objective_index: int):
	var quest = quests[quest_name]
	if quest:
		return quest.objectives[objective_index]
	return false

# Complete a quest
func complete_quest(name: String):
	var quest = quests[name]
	if quest:
		quest.complete()
		# Handle quest completion logic here

func _ready():
	_objectives()
	
func _objectives():
# Example usage
	var objectives = PackedByteArray()
	print(objectives)
	for i in range(10):
		objectives.append(false)

	add_quest("Collect 10 apples", "Collect 10 apples from the orchard", objectives)

	complete_objective("Collect 10 apples", 0)
	complete_objective("Collect 10 apples", 1)

	if is_objective_complete("Collect 10 apples", 0) and is_objective_complete("Collect 10 apples", 1):
		complete_quest("Collect 10 apples")

