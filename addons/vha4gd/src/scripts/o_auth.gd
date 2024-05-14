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

# Called when the node enters the scene tree for the first time.
func _ready():
	var f = FileAccess.open("user://config.json", FileAccess.READ)
	var config = JSON.parse_string(f.get_as_text())
	f.close()
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
			var config = FileAccess.open("user://config.json", FileAccess.READ_WRITE)
			var s = JSON.parse_string(config.get_as_text())
			s["grant_type"] = "authorization_code"
			config.store_string(JSON.stringify(s))
			config.close()
			request_access_token("")
			return false
		auth = true
		load_model_list()
		return false
	model_load_panel.hide()
	oauth.show()
	OS.shell_open("https://hub.vroid.com/oauth/authorize?response_type=code&client_id=" + CLIENT_ID + "&redirect_uri=" + REDIRECT_URI + "&scope=" + SCOPE)

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
			auth_dialog.dialog_text = "認証が完了しました。\nOKボタンを押すとモデルリストが表示されます。"
		"refresh_token":
			post_data += "refresh_token=" + REFRESH_TOKEN
			auth_dialog.dialog_text = "再発行が完了しました。\nOKボタンを押すとモデルリストが表示されます。"
	http_request.name = "AccessTokenRequest"
	http_request.connect("request_completed", Callable(_on_access_token_request_completed))
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
		var f = FileAccess.open("user://config.json", FileAccess.READ_WRITE)
		var config_data = JSON.parse_string(f.get_as_text())
		config_data["access_token"] = access_token
		config_data["refresh_token"] = refresh_token
		f.store_string(JSON.stringify(config_data))
		f.close()
		auth = true
		oauth.hide()
		auth_dialog.title = "成功！"
		auth_dialog.connect("confirmed", Callable(load_model_list))
		add_child(auth_dialog)
		auth_dialog.popup_centered()
	else:
		auth_dialog.title = "エラー"
		auth_dialog.dialog_text = "認証に失敗しました。\nResponse_Code: " + str(response_code)
		add_child(auth_dialog)
		auth_dialog.popup_centered()

func load_model_list():
	if auth:
		VRoidHub.model_list()
