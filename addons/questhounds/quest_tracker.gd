@tool
extends Node
## quests

var quests : Dictionary = {}
var quests_data : Dictionary = {}

## stores currently active quests
var active_quests : Dictionary = {}
## stores competed quests
var complete_quests : Dictionary = {}
## Load quest data from file
var quests_data_file = "res://addons/questhounds/Quests/Quests.json"


func _init() -> void:
	quests_data = _load_quests(quests_data_file)
	quest_data_to_quests()
	
func _load_quests(data_file : String):
	## opens json file and retrives data to populate dictionary to be used with quest system
	if FileAccess.file_exists(data_file):
		
		var quest_data = FileAccess.open(data_file, FileAccess.READ)
		var parsedResult = JSON.parse_string(quest_data.get_as_text())

		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("Error reading file")

	else:
		print("File does not exist")
	
	
## Saves new quest to quests JSON file
func save():
	## save input to json files when SAVE TO FILE button is clicked
	if FileAccess.file_exists(quests_data_file):
		var file = FileAccess.open(quests_data_file, FileAccess.WRITE)
		
		var data_to_send = quests_data
		var json_string = JSON.stringify(data_to_send)
		
		file.store_string(json_string)
		# Close the file
		file.close()

		# Check if the file was written successfully
		if file.get_error() != OK:
			print("Failed to write to file.")
		else:
			print("File written successfully.")
			
func quest_data_to_quests():
	## clear dictionary and replace all with new variables
	quests.clear()
	## populate clean dictionary to be sued with json files
	for i in quests_data:
		var quest = QuestData.new(quests_data[i].quest_name, quests_data[i].quest_desc, quests_data[i].objectives)
		quests[i] = quest
#	print(quests)
#	print(quests_data)
