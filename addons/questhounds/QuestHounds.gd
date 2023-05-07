@tool
extends EditorPlugin

const MainPanel = preload("res://addons/questhounds/Components/quest_hounds_plugin_component.tscn")
var main_panel_instance

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_autoload_singleton("QuestChannel","res://addons/questhounds/quest_channel.gd")
	add_autoload_singleton("QuestTracker","res://addons/questhounds/quest_tracker.gd")
	main_panel_instance = MainPanel.instantiate()
	
#	add_control_to_container(main_panel_instance,"hello",)
	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)
	_make_visible(false)

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
#	remove_autoload_singleton("QuestChannel")
#	remove_autoload_singleton("QuestTracker")
	
	if main_panel_instance:
		main_panel_instance.queue_free()

func _has_main_screen() -> bool:
	return true
	
func _make_visible(visible)-> void:
	if main_panel_instance:
		main_panel_instance.visible = visible

func _get_plugin_name() -> String:
	return "Webhounds Ventures"

func _get_plugin_icon():
	return get_editor_interface().get_base_control().get_theme_icon("Node", "EditorIcons")
