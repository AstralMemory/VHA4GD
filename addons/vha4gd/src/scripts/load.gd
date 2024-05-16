extends Node

const VRMImporter = preload("res://addons/vha4gd/src/scripts/vrm_importer.gd")
var oauth_scene = preload("res://addons/vha4gd/src/scene/o_auth.tscn")
var oauth_inst
var model_list_scene = preload("res://addons/vha4gd/src/scene/model_list.tscn")
var model_list_inst

func start():
	if get_node_or_null("/root/VRoidHub/ModelList"):
		remove_child(model_list_inst)
		model_list_inst.queue_free()
	oauth_inst = oauth_scene.instantiate()
	oauth_inst.position = get_viewport().size / 2
	add_child(oauth_inst)
	
func model_list():
	if get_node_or_null("/root/VRoidHub/OAuth"):
		remove_child(oauth_inst)
		oauth_inst.queue_free()
	model_list_inst = model_list_scene.instantiate()
	model_list_inst.position = get_viewport().size / 2
	add_child(model_list_inst)

func remove():
	if get_node_or_null("/root/VRoidHub/OAuth"):
		remove_child(oauth_inst)
		oauth_inst.queue_free()
	if get_node_or_null("/root/VRoidHub/ModelList"):
		remove_child(model_list_inst)
		model_list_inst.queue_free()

func remove_model():
	if FileAccess.file_exists("res://Model.vrm"):
		DirAccess.remove_absolute("res://Model.vrm")

func load_model(scene_name = "VRoidHub"):
	var root_scene
	if get_node_or_null("/root/" + scene_name):
		root_scene = get_node("/root/" + scene_name + "/")
	if FileAccess.file_exists("res://Model.vrm"):
		var vrm_importer = VRMImporter.new()
		var model = vrm_importer.import_scene("res://Model.vrm")
		if model:
			if get_node("/root/" + scene_name):
				root_scene.add_child(model)

func add_animation_library(name: String, animation_library: AnimationLibrary):
	pass

func play_animation(name: String):
	pass
