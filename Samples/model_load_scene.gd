extends Node3D

var anim = AnimationPlayer.new()
# Called when the node enters the scene tree for the first time.

func _process(delta):
	if get_node_or_null("Model"):
		$Load.hide()
	else:
		$Load.show()

func _on_button_pressed():
	VRoidHub.add_animation_library("Locomotion", load("res://Locomotion-Library.res"), "ModelLoadScene")
	VRoidHub.play_animation("Locomotion/walk", "ModelLoadScene")


func _on_stop_anim_pressed():
	VRoidHub.stop_animation("ModelLoadScene")


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Samples/main.tscn")


func _on_load_pressed():
	VRoidHub.load_model("ModelLoadScene")
