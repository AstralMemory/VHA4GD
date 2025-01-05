extends Control

#region Content
@onready var model_load_panel: Panel = $model_load
@onready var oauth: Panel = $oauth
@onready var oauth_input: LineEdit = $oauth/oauth_code_input
var auth_dialog = AcceptDialog.new()
#endregion

var CLIENT_ID
var CLIENT_SECRET
var REDIRECT_URI
var GRANT_TYPE
var SCOPE
var REFRESH_TOKEN

var access_token_exists

var http_request = HTTPRequest.new()
var auth: bool = false
var oauthing: bool = false
#var lang: int

var local_model_path

# Called when the node enters the scene tree for the first time.
func _ready():
	var config = Config.read_config()
	if config["client_id"] == "" or config["client_secret"] == "" or config["redirect_uri"] == "":
		$model_load/model_load_button.disabled = true
		return false
	access_token_exists = config["access_token"]
	CLIENT_ID = config["client_id"]
	CLIENT_SECRET = config["client_secret"]
	REDIRECT_URI = config["redirect_uri"]
	SCOPE = config["scope"]
	GRANT_TYPE = config["grant_type"]
	REFRESH_TOKEN = config["refresh_token"]
	#lang = int(config["language"])
	
	#match lang:
		#0:
			#$model_load/close.text = "Close"
			#$oauth/oauth_title.text = "Input Authorize Code."
			#$oauth/oauth_title.add_theme_font_size_override("font_size", 30)
			#$oauth/oauth_code_input.placeholder_text = "Authorization Code Here."
			#$oauth/auth.text = "Authorize"
			#$oauth/back.text = "Back"
		#1:
			#$model_load/close.text = "閉じる"
			#$oauth/oauth_title.text = "認証コード入力"
			#$oauth/oauth_title.add_theme_font_size_override("font_size", 50)
			#$oauth/oauth_code_input.placeholder_text = "認証コードを入力してください"
			#$oauth/auth.text = "認証"
			#$oauth/back.text = "戻る"
	$model_load/close.text = "閉じる"
	$oauth/oauth_title.text = "認証コード入力"
	$oauth/oauth_title.add_theme_font_size_override("font_size", 50)
	$oauth/oauth_code_input.placeholder_text = "認証コードを入力してください"
	$oauth/auth.text = "認証"
	$oauth/back.text = "戻る"

#region mode_select
func _on_back_pressed():
	model_load_panel.show()
	oauth.hide()

func _on_close_pressed():
	VRoidHub.remove()
#endregion

#region MainProcess

func _on_model_load_button_pressed():
	VRoidHub.remove_model()
	if access_token_exists != "":
		if GRANT_TYPE == "refresh_token":
			Config.rewrite_config("rewrite", "grant_type", "authorization_code")
			request_access_token("")
			return false
		auth = true
		load_model_list()
		return false
	model_load_panel.hide()
	oauth.show()
	OS.shell_open("https://hub.vroid.com/oauth/authorize?response_type=code&client_id=" + CLIENT_ID + "&redirect_uri=" + REDIRECT_URI + "&scope=" + SCOPE)

func local_model_load():
	#match lang:
		#0:
			#$model_load/SelectVRMFile.ok_button_text = "Select"
			#$model_load/SelectVRMFile.cancel_button_text = "Cancel"
		#1:
			#$model_load/SelectVRMFile.ok_button_text = "選択"
			#$model_load/SelectVRMFile.cancel_button_text = "キャンセル"
	$model_load/SelectVRMFile.ok_button_text = "選択"
	$model_load/SelectVRMFile.cancel_button_text = "キャンセル"
	$model_load/SelectVRMFile.popup()
			

func _on_auth_pressed():
	var auth_code = oauth_input.text
	request_access_token(auth_code)

func request_access_token(auth_code: String):
	var post_data = "client_id=" + CLIENT_ID + "&"
	post_data += "client_secret=" + CLIENT_SECRET + "&"
	post_data += "grant_type=" + GRANT_TYPE + "&"
	post_data += "redirect_uri=" + REDIRECT_URI + "&"
	match GRANT_TYPE:
		"authorization_code":
			post_data += "code=" + auth_code
			#match lang:
				#0:
					#auth_dialog.dialog_text = "Authorized!\nPress OK to Show ModelList."
				#1:
					#auth_dialog.dialog_text = "認証が完了しました。\nOKボタンを押すとモデルリストが表示されます。"
			auth_dialog.dialog_text = "認証が完了しました。\nOKボタンを押すとモデルリストが表示されます。"
		"refresh_token":
			post_data += "refresh_token=" + REFRESH_TOKEN
			#match lang:
				#0:
					#auth_dialog.dialog_text = "Reissuance is complete. \nClick the OK button to display the model list."
				#1:
					#auth_dialog.dialog_text = "再発行が完了しました。\nOKボタンを押すとモデルリストが表示されます。"
			auth_dialog.dialog_text = "再発行が完了しました。\nOKボタンを押すとモデルリストが表示されます。"
	http_request.name = "AccessTokenRequest"
	http_request.connect("request_completed", Callable(self, "_on_access_token_request_completed"))
	add_child(http_request)
	http_request.request("https://hub.vroid.com/oauth/token", ["X-Api-Version: 11"], HTTPClient.METHOD_POST, post_data)

func _on_access_token_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	if response_code == 200:
		remove_child(http_request)
		http_request.queue_free()
		var response = json.parse_string(body.get_string_from_utf8())
		var access_token = response.access_token
		var refresh_token = response.refresh_token
		Config.rewrite_config("rewrite", "access_token", access_token, 1)
		Config.rewrite_config("rewrite", "refresh_token", refresh_token, 1)
		auth = true
		oauth.hide()
		#match lang:
			#0:
				#auth_dialog.title = "Success!"
			#1:
				#auth_dialog.title = "成功!"
		auth_dialog.title = "成功!"
		auth_dialog.connect("confirmed", Callable(load_model_list))
		add_child(auth_dialog)
		auth_dialog.popup_centered()
	else:
		#match lang:
			#0:
				#auth_dialog.title = "Error!"
				#auth_dialog.dialog_text = "Authentication failed.\nResponse_Code: " + str(response_code)
			#1:
				#auth_dialog.title = "エラー"
				#auth_dialog.dialog_text = "認証に失敗しました。\nResponse_Code: " + str(response_code)
		auth_dialog.title = "エラー"
		auth_dialog.dialog_text = "認証に失敗しました。\nResponse_Code: " + str(response_code)
		add_child(auth_dialog)
		auth_dialog.popup_centered()

func load_model_list():
	if auth:
		VRoidHub._model_list()


func _on_select_vrm_file_file_selected(path):
	var config = Config.read_config()
	if config["change_scene"] == "true":
		get_tree().change_scene_to_file(config["scene_path"])
	await get_tree().tree_changed
	VRoidHub.load_model(config["localvrm"], path)
	VRoidHub.remove()


func _on_model_load_button_2_pressed():
	$model_load/SelectVRMFile.popup()
