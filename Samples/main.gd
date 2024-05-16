extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


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
