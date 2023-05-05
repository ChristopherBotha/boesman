extends Node

# q_name = name of new quest
# q_desc = description of new quest
# q_reward = reward player gets when completing quest

signal quest_activated(q_name,q_desc,q_reward) 
signal current_quest(q_name,q_desc,q_reward)
signal quest_completed(q_name)
