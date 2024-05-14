# このスクリプトはControlノードを拡張し、ツールスクリプトとして使用されます。
@tool
extends Control

@onready var access_token: Label = $AccessToken
@onready var character_id: Label = $CharacterID
@onready var popup_panel: PopupPanel = $PopupPanel
@onready var popup_label: Label = $PopupPanel/Label
@onready var client_id: LineEdit = $ClientIDNode/ClientID
@onready var client_secret: LineEdit = $ClientSecretNode/ClientSecret
@onready var redirect_uri: LineEdit = $RedirectURINode/RedirectURI
@onready var scope: LineEdit = $ScopeNode/Scope
@onready var refresh_token: Label = $RefreshToken

# ノードがシーンツリーに最初に入るときに呼び出されます。
func _ready():
	if !DirAccess.dir_exists_absolute("res://addons/vrm"):
		popup_panel.popup_centered()
	var config_file = FileAccess.open("user://config.json", FileAccess.READ)
	var s = JSON.parse_string(config_file.get_as_text())
	config_file.close()
	access_token.text = s["access_token"]
	character_id.text = s["character_id"]
	refresh_token.text = s["refresh_token"]
	redirect_uri.text = s["redirect_uri"]
	client_id.text = s["client_id"]
	scope.text = s["scope"]
	client_secret.text = s["client_secret"]

func _on_set_button_pressed():
	var config_file = FileAccess.open("user://config.json", FileAccess.READ_WRITE)
	var config_data = JSON.parse_string(config_file.get_as_text())
	if client_id.text.is_empty() or client_secret.text.is_empty() or redirect_uri.text.is_empty():
		popup_label.text = "いずれかの値が空白です。"
		popup_panel.popup_centered()
		return false
	config_data["client_id"] = client_id.text
	config_data["client_secret"] = client_secret.text
	config_data["redirect_uri"] = redirect_uri.text
	config_data["scope"] = scope.text
	config_file.store_string(JSON.stringify(config_data))
	config_file.close()
	popup_panel.title = "完了！"
	popup_label.text = "設定を保存しました。"
	popup_panel.popup_centered()


func _on_refresh_button_pressed():
	var config_file = FileAccess.open("user://config.json", FileAccess.READ)
	var s = JSON.parse_string(config_file.get_as_text())
	config_file.close()
	access_token.text = s["access_token"]
	character_id.text = s["character_id"]
	refresh_token.text = s["refresh_token"]
	redirect_uri.text = s["redirect_uri"]
	client_id.text = s["client_id"]
	scope.text = s["scope"]
	client_secret.text = s["client_secret"]


func _on_clear_button_pressed():
	var config_file = FileAccess.open("user://config.json", FileAccess.READ_WRITE)
	var s = JSON.parse_string(config_file.get_as_text())
	config_file.close()
	access_token.text = ""
	character_id.text = ""
	refresh_token.text = ""
	redirect_uri.text = s["redirect_uri"]
	client_id.text = s["client_id"]
	scope.text = s["scope"]
	client_secret.text = s["client_secret"]
	s["access_token"] = ""
	s["character_id"] = ""
	s["refresh_token"] = ""
	DirAccess.remove_absolute("user://config.json")
	var new_conf = FileAccess.open("user://config.json", FileAccess.WRITE)
	var config_data = {
		"access_token": "",
		"character_id": "",
		"refresh_token": "",
		"client_id": s["client_id"],
		"client_secret": s["client_secret"],
		"redirect_uri": s["redirect_uri"],
		"scope": s["scope"],
		"grant_type": "authorization_code"
	}
	new_conf.store_string(JSON.stringify(config_data))
	new_conf.close()
