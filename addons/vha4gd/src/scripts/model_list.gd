extends Control

#region 変数関連
var mymodel_data_request = HTTPRequest.new()
var mymodel_image_request = HTTPRequest.new()
var favorite_data_request = HTTPRequest.new()
var favorite_image_request = HTTPRequest.new()
var mdl_request = HTTPRequest.new()
var license_request = HTTPRequest.new()

const MYMODEL_API = "https://hub.vroid.com/api/account/character_models"
var FAVORITE_API
const ModelDownload_API = "https://hub.vroid.com/api/download_licenses"
var header = []
var mdl_header = []

var mymodel_count = 0
var favorite_count = 0
var mymodel_image_queue: Array = []
var favorite_image_queue: Array = []
var mymodel_current_request_index: int = 0
var favorite_current_request_index: int = 0
var mymodel_character_id: Array = []
var favorite_character_id: Array = []

var client_id
var client_secret
var grant_type
var character_id
var redirect_uri
var scope
var refresh_token
var access_token

@onready var MyModelPanel = $model_select/MyModel
@onready var FavoriteModelPanel = $model_select/FavoriteModel
@onready var MyGridContainer = $model_select/MyModel/PanelContainer/VBoxContainer/GridContainer
@onready var FavoriteGridContainer = $model_select/FavoriteModel/PanelContainer/VBoxContainer/GridContainer
#endregion

func _init():
	DirAccess.make_dir_absolute("user://temp")
	DirAccess.make_dir_absolute("user://temp/button_icon")
	DirAccess.make_dir_absolute("user://temp/button_icon/favorite")

# Called when the node enters the scene tree for the first time.
func _ready():
	var config = Config.read_config()
	match int(config["language"]):
		0:
			$model_select/close.text = "Close"
		1:
			$model_select/close.text = "閉じる"
	FAVORITE_API = "https://hub.vroid.com/api/hearts?" + config["client_id"]
	header = ["X-Api-Version: 11", "Authorization: Bearer " + config["access_token"]]
	mdl_header = ["X-Api-Version: 11", "Authorization: Bearer " + config["access_token"], "Content-Type: application/x-www-form-urlencoded"]
	mymodel_data_request_process(MYMODEL_API, header)
	favorite_data_request_process(FAVORITE_API, header)

#region モデルリスト
func mymodel_data_request_process(api, header):
	mymodel_data_request.name = "MyModelRequest"
	mymodel_data_request.connect("request_completed", Callable(self, "_on_mymodel_data_request_completed"))
	add_child(mymodel_data_request)
	mymodel_data_request.request(api, header)

func favorite_data_request_process(api, header):
	favorite_data_request.name = "FavoriteModelRequest"
	favorite_data_request.connect("request_completed", Callable(self, "_on_favorite_data_request_completed"))
	add_child(favorite_data_request)
	favorite_data_request.request(api, header)

func _on_mymodel_data_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	if response_code == 200:
		var response = json.parse_string(body.get_string_from_utf8())
		mymodel_count = 0
		if "data" in response:
			for model in response["data"]:
				if "portrait_image" in model and "sq150" in model["portrait_image"] and "url" in model["portrait_image"]["sq150"]:
					mymodel_image_queue.append(model["portrait_image"]["sq150"]["url"])
					mymodel_character_id.append(model["id"])
				else:
					print("Image URL not Found for one of the models.")
			_request_next_mymodel_image()
		else:
			print("MyModel Error: " + str(response_code))
	elif response_code == 401:
		Config.rewrite_config("rewrite", "grant_type", "refresh_token")
		Dialog.access_token_error_dialog()
	else:
		print("MyModel Error: " + str(response_code) + "\n" + body.get_string_from_utf8())

func _on_favorite_data_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	if response_code == 200:
		var response = json.parse_string(body.get_string_from_utf8())
		favorite_count = 0
		if "data" in response:
			for model in response["data"]:
				if "portrait_image" in model and "sq150" in model["portrait_image"] and "url" in model["portrait_image"]["sq150"]:
					favorite_image_queue.append(model["portrait_image"]["sq150"]["url"])
					favorite_character_id.append(model["id"])
				else:
					print("Image URL not Found for one of the models.")
			_request_next_favorite_image()
		else:
			print("FavoriteModel Error: " + str(response_code))
			
func _request_next_mymodel_image():
	if mymodel_current_request_index < mymodel_image_queue.size():
		var image_url = mymodel_image_queue[mymodel_current_request_index]
		if !get_node_or_null("MyModelRequest"):
			remove_child(mymodel_data_request)
		if !get_node_or_null("MyModelImageRequest"):
			mymodel_image_request.name = "MyModelImageRequest"
			mymodel_image_request.connect("request_completed", Callable(self, "_on_mymodel_image_request_completed"))
			add_child(mymodel_image_request)
		mymodel_image_request.request(image_url)

func _request_next_favorite_image():
	if favorite_current_request_index < favorite_image_queue.size():
		var image_url = favorite_image_queue[favorite_current_request_index]
		if !get_node_or_null("FavoriteModelRequest"):
			remove_child(favorite_data_request)
		if !get_node_or_null("FavoriteImageRequest"):
			favorite_image_request.name = "FavoriteImageRequest"
			favorite_image_request.connect("request_completed", Callable(self, "_on_favorite_image_request_completed"))
			add_child(favorite_image_request)
		favorite_image_request.request(image_url)

func _on_mymodel_image_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var img = Image.new()
		var err = img.load_jpg_from_buffer(body)
		if err == OK:
			if !DirAccess.dir_exists_absolute("user://temp/button_icon"):
				DirAccess.make_dir_absolute("user://temp/button_icon")
			img.save_jpg("user://temp/button_icon/mymodel" + str(mymodel_current_request_index) + ".jpg")
			var btn = TextureButton.new()
			btn.connect("pressed", _on_btn_pressed.bind("mymodel_button" + str(mymodel_current_request_index), "mymodel"))
			await(!FileAccess.file_exists("user://temp/button_icon/mymodel" + str(mymodel_current_request_index) + ".jpg"))
			var timer = Timer.new()
			add_child(timer)
			timer.start(1)
			await(timer.timeout)
			remove_child(timer)
			var icon = FileAccess.open("user://temp/button_icon/mymodel" + str(mymodel_current_request_index) + ".jpg", FileAccess.READ)
			var icon_data = icon.get_buffer(icon.get_length())
			icon.close()
			if img.load_jpg_from_buffer(icon_data) == OK:
				var tex = ImageTexture.new()
				btn.texture_normal = tex.create_from_image(img)
			else:
				print("MyButtonCreateError!")
			var id = mymodel_character_id[mymodel_current_request_index]
			btn.set_meta("character_id", id)
			btn.name = "mymodel_button" + str(mymodel_current_request_index)
			MyGridContainer.add_child(btn)
		mymodel_current_request_index += 1
		_request_next_mymodel_image()
	else:
		print("Failed to fetch image. Response Code: ", str(response_code))

func _on_favorite_image_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var img = Image.new()
		var err = img.load_jpg_from_buffer(body)
		if err == OK:
			if !DirAccess.dir_exists_absolute("user://temp/button_icon/favorite"):
				DirAccess.make_dir_absolute("user://temp/button_icon/favorite")
			img.save_jpg("user://temp/button_icon/favorite/favorite" + str(favorite_current_request_index) + ".jpg")
			var btn = TextureButton.new()
			btn.connect("pressed", _on_btn_pressed.bind("favorite_button" + str(favorite_current_request_index), "favorite"))
			await(!FileAccess.file_exists("user://temp/button_icon/favorite/favorite" + str(favorite_current_request_index) + ".jpg"))
			var timer = Timer.new()
			add_child(timer)
			timer.start(1)
			await(timer.timeout)
			remove_child(timer)
			var icon = FileAccess.open("user://temp/button_icon/favorite/favorite" + str(favorite_current_request_index) + ".jpg", FileAccess.READ)
			var icon_data = icon.get_buffer(icon.get_length())
			icon.close()
			if img.load_jpg_from_buffer(icon_data) == OK:
				var tex = ImageTexture.new()
				btn.texture_normal = tex.create_from_image(img)
			else:
				print("FavoriteButtonCreateError!")
				get_tree().quit()
			var id = favorite_character_id[favorite_current_request_index]
			btn.set_meta("character_id", id)
			btn.name = "favorite_button" + str(favorite_current_request_index)
			FavoriteGridContainer.add_child(btn)
		favorite_current_request_index += 1
		_request_next_favorite_image()
	else:
		print("Failed to fetch image. Response Code: ", str(response_code))

func _on_mode_select_tab_changed(tab):
	match tab:
		0:
			MyModelPanel.show()
			FavoriteModelPanel.hide()
		1:
			MyModelPanel.hide()
			FavoriteModelPanel.show()
		2:
			pass

func _on_btn_pressed(pressed_button, mode):
	match mode:
		"mymodel":
			var btn = get_node("/root/VRoidHub/ModelList/model_select/MyModel/PanelContainer/VBoxContainer/GridContainer/" + pressed_button)
			Config.rewrite_config("rewrite", "character_id", btn.get_meta("character_id"), 1)
			model_download(btn.get_meta("character_id"))
		"favorite":
			var btn = get_node("/root/VRoidHub/ModelList/model_select/FavoriteModel/PanelContainer/VBoxContainer/GridContainer/" + pressed_button)
			Config.rewrite_config("rewrite", "character_id", btn.get_meta("character_id"), 1)
			model_download(btn.get_meta("character_id"))
#endregion

#region モデルダウンロード
func model_download(character_id):
	var confs = Config.read_config()
	match int(confs["language"]):
		0:
			$Loading/Label.text = "Now Downloading..."
		1:
			$Loading/Label.text = "モデルのダウンロード中"
	$Loading.popup_centered()
	for button in $model_select.get_children():
		if button is BaseButton:
			button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var chara_post: String = "character_model_id=" + character_id
	license_request.connect("request_completed", Callable(self, "_on_license_request_completed"))
	license_request.name = "LicenseRequest"
	add_child(license_request)
	license_request.request(ModelDownload_API, mdl_header, HTTPClient.METHOD_POST, chara_post)

func _on_license_request_completed(result, response_code, headers, body):
	if response_code == 200:
		remove_child(license_request)
		license_request.queue_free()
		var response = JSON.parse_string(body.get_string_from_utf8())
		var download_license_id = response["data"]["id"]
		mdl_request.connect("request_completed", Callable(self, "_on_model_request_completed"))
		mdl_request.name = "ModelRequest"
		mdl_request.set_download_file("res://Model.vrm")
		add_child(mdl_request)
		mdl_request.request(ModelDownload_API + "/" + str(download_license_id) + "/download", mdl_header, HTTPClient.METHOD_GET)
	else:
		print("Failed Get License! Response Code:" + str(response_code) + "\n" + body.get_string_from_utf8())

func _on_model_request_completed(result, response_code, headers, body):
	if response_code == 302:
		var url_pattern = RegEx.new()
		url_pattern.compile('<a href="(.+?)">')
		url_pattern.search(body)
		
		var redirect_url = url_pattern.get_string(1)
		
		if redirect_url:
			mdl_request.request(redirect_url)
	elif response_code == 200:
		remove_child(mdl_request)
		mdl_request.queue_free()
		Dialog.download_completed_dialog()
	else:
		print("Failed to download file. Response Code:" + str(response_code) + "\n" + body.get_string_from_utf8())


func _on_close_pressed():
	VRoidHub.remove()
