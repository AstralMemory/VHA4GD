@tool
extends EditorPlugin

var config_scene = preload("res://addons/vha4gd/src/scene/config.tscn")
var config = config_scene.instantiate()

func _enter_tree():
	add_autoload_singleton("VRoidHub", "res://addons/vha4gd/src/scripts/load.gd")
	add_autoload_singleton("Dialog", "res://addons/vha4gd/src/scene/dialog.tscn")
	if !FileAccess.file_exists("user://config.json"):
		var f = FileAccess.open("user://config.json", FileAccess.WRITE)
		var config_data = {
			"access_token": "",
			"refresh_token": "",
			"character_id": "",
			"client_id": "",
			"client_secret": "",
			"redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
			"scope": "default",
			"grant_type": "authorization_code"
		}
		var s = JSON.stringify(config_data)
		f.store_string(s)
		f.close()
	# Initialization of the plugin goes here.
	EditorInterface.get_editor_main_screen().add_child(config)
	config.hide()

func _has_main_screen():
	return true
	
func _make_visible(visible):
	config.visible = visible
	
func _get_plugin_name():
	return "VHA4GD"

func _get_plugin_icon():
	return preload("res://addons/vha4gd/src/interface_icon.png")
	return EditorInterface.get_editor_theme().get_icon(config, "res://addons/vha4gd/src/interface_icon.png")

func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_autoload_singleton("VRoidHub")
	remove_autoload_singleton("Dialog")
	EditorInterface.get_editor_main_screen().remove_child(config)
	config.free()
