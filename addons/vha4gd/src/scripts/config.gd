@tool
extends Node

#var lang: int

func _init():
	if !FileAccess.file_exists("res://config.json"):
		var f = FileAccess.open("res://config.json", FileAccess.WRITE)
		var config_data = {
			"access_token": "",
			"refresh_token": "",
			"character_id": "",
			"client_id": "",
			"client_secret": "",
			"redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
			"scope": "default",
			"localvrm": "VRoidHub",
			"change_scene": "false",
			"scene_path": "",
			"grant_type": "authorization_code",
			#"language": 0
		}
		#var data = var_to_bytes(config_data)
		#f.store_buffer(data)
		var data = JSON.stringify(config_data)
		f.store_string(config_data)
		f.flush()
		f.close()

func rewrite_config(mode: String = "rewrite", key: String = "", value: String = "", hide_message = 0):
	match mode:
		"rewrite":
			if FileAccess.file_exists("res://config.json"):
				var config_file = FileAccess.open("res://config.json", FileAccess.READ)
				#if config_file.get_length():
					#var config_data = bytes_to_var(config_file.get_buffer(config_file.get_length()))
				var config_data = JSON.parse_string(config_file.get_as_text())
				config_file.close()
				DirAccess.remove_absolute("res://config.json")
				var new_config = FileAccess.open("res://config.json", FileAccess.WRITE)
					#lang = int(config_data["language"])
				if key != "" and value != "":
					if config_data.has(key):
						config_data[key] = value
					else:
							#match lang:
								#0:
									#Dialog.free_dialog("Not Found Key.")
								#1:
									#Dialog.free_dialog("キーが見つかりません。")
						Dialog.free_dialog("キーが見つかりません。")
						return false
				elif key == "" or value == "":
						#match lang:
							#0:
								#Dialog.free_dialog("Value Empty!")
							#1:
								#Dialog.free_dialog("いずれかの値が空白です。")
					Dialog.free_dialog("いずれかの値が空白です。")
					return false
					#new_config.store_buffer(var_to_bytes(config_data))
				new_config.store_string(JSON.stringify(config_data))
				new_config.flush()
				new_config.close()
				if hide_message == 0:
						#match lang:
							#0:
								#Dialog.free_dialog("Save Config!", "Completed!")
							#1:
								#Dialog.free_dialog("設定を保存しました。", "完了！")
					Dialog.free_dialog("設定を保存しました。", "完了！")
				#else:
					#match lang:
						#0:
							#Dialog.free_dialog("Broken Config File.\nPlease Press Reset Config File Button.")
						#1:
							#Dialog.free_dialog("Configファイルが壊れています。\nReset Config Fileボタンを押して、Configを削除してください。")
					#Dialog.free_dialog("Configファイルが壊れています。\nReset Config Fileボタンを押して、Configを削除してください。")
		"delete":
			DirAccess.remove_absolute("res://config.json")
			var f = FileAccess.open("res://config.json", FileAccess.WRITE)
			var config_data = {
				"access_token": "",
				"refresh_token": "",
				"character_id": "",
				"client_id": "",
				"client_secret": "",
				"redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
				"scope": "default",
				"localvrm": "VRoidHub",
				"change_scene": "false",
				"scene_path": "",
				"grant_type": "authorization_code",
				#"language": lang
			}
			#var data = var_to_bytes(config_data)
			#f.store_buffer(data)
			var data = JSON.stringify(config_data)
			f.store_string(data)
			f.flush()
			f.close()
			#match lang:
				#0:
					#Dialog.free_dialog("Reset Config.", "Completed!")
				#1:
					#Dialog.free_dialog("Configファイルを再生成しました。", "完了")
			Dialog.free_dialog("Configファイルを再生成しました。", "完了")

func read_config():
	if FileAccess.file_exists("res://config.json"):
		var config_file = FileAccess.open("res://config.json", FileAccess.READ)
		if config_file.get_length():
			#var return_config = bytes_to_var(config_file.get_buffer(config_file.get_length()))
			var return_config = JSON.parse_string(config_file.get_as_text())
			config_file.close()
			return return_config
		else:
			return null
	else:
		return null
