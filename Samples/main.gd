extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Config.rewrite_config("rewrite", "client_id", "e4JzHnT6zeek8HJ5ZdAvwqwp09f3hqfgC98JtLJz4Rw", 1)
	Config.rewrite_config("rewrite", "client_secret", "m6F6H49bC2o3C3Vxf_4Zvbw_rjN_KEm-uc8i0MKPrz8", 1)
	Config.rewrite_config("rewrite", "localvrm", "ModelLoadScene", 1)
	Config.rewrite_config("rewrite", "scene_path", "res://Samples/model_load_scene.tscn", 1)
	Config.rewrite_config("rewrite", "change_scene", "true", 1)
	#Config.rewrite_config("rewrite", "language", "1", 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !get_node_or_null("/root/VRoidHub/OAuth") and !get_node_or_null("/root/VRoidHub/ModelList"):
		$VHStart.show()
		$ModelLoad.show()
		$VHStart.disabled = false
		if FileAccess.file_exists("res://Model.vrm"):
			$ModelLoad.disabled = false
	else:
		return false

func _on_vh_start_pressed():
	$VHStart.hide()
	$ModelLoad.hide()
	VRoidHub.start()


func _on_model_load_pressed():
	get_tree().change_scene_to_file("res://Samples/model_load_scene.tscn")
