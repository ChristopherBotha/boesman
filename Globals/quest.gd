extends Object
class_name Quest

enum QuestState {
	Inactive,
	Active,
	Completed
}

var _questsChannel: QuestChannel

var UniqueId: String
var Name: String
var State: QuestState = QuestState.Inactive
var LevelRequirement: int
var ExperienceReward: int

func enable():
	_questsChannel.connect("quest_activated", quest_active_event)
	_questsChannel.connect("quest_completed", quest_completed_event)
	
	if State == QuestState.Active:
		quest_active()

func disable():
	_questsChannel.disconnect("quest_activated", quest_active_event)
	_questsChannel.disconnect("quest_completed", quest_completed_event)

func quest_active_event(active_quest: Quest):
	if active_quest.UniqueId != UniqueId:
		return
	
	State = QuestState.Active
	quest_active()

func quest_active():
	pass # to be implemented in subclasses	

func quest_completed_event(completed_quest: Quest):
	if completed_quest.UniqueId != UniqueId:
		return
	
	State = QuestState.Completed
	quest_completed()

func quest_completed():
	pass # to be implemented in subclasses	

func complete():
	_questsChannel.complete_quest(self)	
