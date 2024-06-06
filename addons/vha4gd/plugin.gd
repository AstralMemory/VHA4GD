@tool
extends EditorPlugin

var config_scene = preload("res://addons/vha4gd/src/scene/config.tscn")
var config_scene_inst = config_scene.instantiate()

func _enter_tree():
	add_autoload_singleton("VRoidHub", "res://addons/vha4gd/src/scripts/load.gd")
	add_autoload_singleton("Dialog", "res://addons/vha4gd/src/scene/dialog.tscn")
	add_autoload_singleton("Config", "res://addons/vha4gd/src/scripts/config.gd")
	# Initialization of the plugin goes here.
	EditorInterface.get_editor_main_screen().add_child(config_scene_inst)
	config_scene_inst.hide()

func _has_main_screen():
	return true
	
func _make_visible(visible):
	config_scene_inst.visible = visible
	
func _get_plugin_name():
	return "VHA4GD"

func _get_plugin_icon():
	return preload("res://addons/vha4gd/src/interface_icon.png")
	return EditorInterface.get_editor_theme().get_icon(config_scene_inst, "res://addons/vha4gd/src/interface_icon.png")

func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_autoload_singleton("VRoidHub")
	remove_autoload_singleton("Dialog")
	remove_autoload_singleton("Config")
	EditorInterface.get_editor_main_screen().remove_child(config_scene_inst)
	config_scene_inst.free()
