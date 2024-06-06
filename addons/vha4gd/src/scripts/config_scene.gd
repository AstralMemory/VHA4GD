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
@onready var localvrm: LineEdit = $LocalVRMNode/LocalVRM
@onready var change_scene: CheckButton = $LocalVRMNode/ChangeScene
@onready var scene_path: LineEdit = $LocalVRMNode/ScenePath
@onready var refresh_token: Label = $RefreshToken
@onready var langtitle: Label = $LanguageTitle
@onready var langsel: OptionButton = $LangSelect
var lang: int

# ノードがシーンツリーに最初に入るときに呼び出されます。
func _ready():
	var s = Config.read_config()
	access_token.text = s["access_token"]
	character_id.text = s["character_id"]
	refresh_token.text = s["refresh_token"]
	redirect_uri.text = s["redirect_uri"]
	client_id.text = s["client_id"]
	scope.text = s["scope"]
	localvrm.text = s["localvrm"]
	match s["change_scene"]:
		"true":
			change_scene.button_pressed = true
			scene_path.editable = true
		"false":
			change_scene.button_pressed = false
			scene_path.editable = false
	client_secret.text = s["client_secret"]
	langsel.selected = int(s["language"])
	lang = int(s["language"])
	if !DirAccess.dir_exists_absolute("res://addons/vrm"):
		match lang:
			0:
				$PopupPanel/Label.text = "Not Found VRM Plugin."
			1:
				$PopupPanel/Label.text = "VRMプラグインがインストールされていません。\nこのまま実行するとエラーが起きます。"
		popup_panel.popup_centered()

func _process(delta):
	match lang:
		0:
			langtitle.text = "Language"
			langsel.set_item_text(0, "english")
			langsel.set_item_text(1, "japanese")
		1:
			langtitle.text = "言語"
			langsel.set_item_text(0, "英語")
			langsel.set_item_text(1, "日本語")

func _on_set_button_pressed():
	Config.rewrite_config("rewrite", "client_id", client_id.text)
	Config.rewrite_config("rewrite", "client_secret", client_secret.text)
	Config.rewrite_config("rewrite", "redirect_uri", redirect_uri.text)
	Config.rewrite_config("rewrite", "scope", scope.text)
	Config.rewrite_config("rewrite", "localvrm", localvrm.text)
	match change_scene.button_pressed:
		true:
			Config.rewrite_config("rewrite", "change_scene", "true")
			scene_path.editable = true
		false:
			Config.rewrite_config("rewrite", "change_scene", "false")
			scene_path.editable = false
	Config.rewrite_config("rewrite", "scene_path", scene_path.text)
	Config.rewrite_config("rewrite", "language", str(langsel.get_selected_id()))
	lang = langsel.get_selected_id()


func _on_refresh_button_pressed():
	var s = Config.read_config()
	access_token.text = s["access_token"]
	character_id.text = s["character_id"]
	refresh_token.text = s["refresh_token"]
	redirect_uri.text = s["redirect_uri"]
	client_id.text = s["client_id"]
	scope.text = s["scope"]
	localvrm.text = s["localvrm"]
	match s["change_scene"]:
		"true":
			change_scene.button_pressed = true
			scene_path.editable = true
			scene_path.text = s["scene_path"]
		"false":
			change_scene.button_pressed = false
			scene_path.editable = false
			scene_path.text = ""
	client_secret.text = s["client_secret"]
	langsel.selected = int(s["language"])


func _on_clear_button_pressed():
	var config_data = Config.read_config()
	if config_data == null:
		match lang:
			0:
				Dialog.free_dialog("Don't Get Config.")
			1:
				Dialog.free_dialog("Configの取得に失敗しました。")
		return false
	access_token.text = ""
	character_id.text = ""
	refresh_token.text = ""
	redirect_uri.text = config_data["redirect_uri"]
	client_id.text = config_data["client_id"]
	scope.text = config_data["scope"]
	localvrm.text = config_data["localvrm"]
	match config_data["change_scene"]:
		"true":
			change_scene.button_pressed = true
			scene_path.editable = true
			scene_path.text = config_data["scene_path"]
		"false":
			change_scene.button_pressed = false
			scene_path.editable = false
			scene_path.text = ""
	client_secret.text = config_data["client_secret"]
	Config.rewrite_config()
			


func _on_reset_config_file_button_pressed():
	Config.rewrite_config("delete")
	access_token.text = ""
	character_id.text = ""
	refresh_token.text = ""
	redirect_uri.text = "urn:ietf:wg:oauth:2.0:oob"
	client_id.text = ""
	scope.text = "default"
	localvrm.text = "VRoidHub"
	change_scene.button_pressed = false
	scene_path.editable = false
	scene_path.text = ""
	client_secret.text = ""
