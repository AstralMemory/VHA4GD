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
	add_child(oauth_inst)
	
func _model_list():
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

func load_model(scene_name = "VRoidHub", model_path = "res://Model.vrm"):
	var root_scene
	if get_node_or_null("/root/" + scene_name):
		root_scene = get_node("/root/" + scene_name + "/")
	if FileAccess.file_exists(model_path):
		var vrm_importer = VRMImporter.new()
		var model = vrm_importer.import_scene(model_path)
		if model:
			if get_node("/root/" + scene_name):
				root_scene.add_child(model)

func add_animation_library(library_name: String, animation_library: AnimationLibrary, scene_name = "VRoidHub"):
	var anim_player: AnimationPlayer
	if get_node_or_null("/root/" + scene_name):
		anim_player = get_node("/root/" + scene_name + "/Model/AnimationPlayer")
		if anim_player == null:
			var confs = Config.read_config()
			match int(confs["language"]):
				0:
					Dialog.free_dialog("Not Found AnimationPlayerNode.")
				1:
					Dialog.free_dialog("アニメーションプレイヤーが見つかりません。")
			return false
		else:
			if !anim_player.has_animation_library(library_name):
				anim_player.add_animation_library(library_name, animation_library)
	
func play_animation(animation_name: String, scene_name = "VRoidHub"):
	var anim_player: AnimationPlayer
	if get_node_or_null("/root/" + scene_name):
		anim_player = get_node("/root/" + scene_name + "/Model/AnimationPlayer")
		if anim_player == null:
			var confs = Config.read_config()
			match int(confs["language"]):
				0:
					Dialog.error_dialog("Not Found AnimationPlayerNode.")
				1:
					Dialog.error_dialog("アニメーションプレイヤーが見つかりません。")
			return false
		else:
			anim_player.play(animation_name)

func stop_animation(scene_name = "VRoidHub"):
	var anim_player: AnimationPlayer
	if get_node_or_null("/root/" + scene_name):
		anim_player = get_node("/root/" + scene_name + "/Model/AnimationPlayer")
		if anim_player == null:
			var confs = Config.read_config()
			match int(confs["language"]):
				0:
					Dialog.error_dialog("Not Found AnimationPlayerNode.")
				1:
					Dialog.error_dialog("アニメーションプレイヤーが見つかりません。")
			return false
		else:
			anim_player.stop()
