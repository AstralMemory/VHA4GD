@tool
extends Control

var confs
var lang: int
var game_quit: bool = false

func _ready():
	self.hide()
	confs = Config.read_config()
	lang = int(confs["language"])

func download_completed_dialog():
	match lang:
		0:
				$DownloadCompleted.title = "Success!"
				$DownloadCompleted/Label.text = "Download Completed.\nPlease Restart a Game."
		1:
				$DownloadCompleted.title = "完了！"
				$DownloadCompleted/Label.text = "ダウンロードが完了しました。\nゲームを再起動してください。"
	self.show()
	$DownloadCompleted.popup_centered()
	
func access_token_error_dialog():
	match lang:
		0:
			$AccessTokenError.dialog_text = "Token Expired.\nPress Start Button Again."
		1:
			$AccessTokenError.dialog_text = "アクセストークンの有効期限が切れているため\n認証画面へ戻ります。\n再度開始ボタンを押してください。"
	self.show()
	$AccessTokenError.popup_centered()

func no_vrm_plugin_dialog():
	match lang:
		0:
			$NoVRMPlugin.dialog_text = "Not Found VRM Plugin.\nCan't Model Load."
		1:
			$NoVRMPlugin.dialog_text = "VRMプラグインがインストールされていないため\nモデルのロードができません。"
	self.show()
	$NoVRMPlugin.popup_centered()

func free_dialog(message: String, title: String = "Error!"):
	self.show()
	$Error.title = title
	$Error.dialog_text = message
	$Error.popup_centered()

func remove_dialog():
	self.hide()
	$DownloadCompleted.hide()
	$AccessTokenError.hide()
	$NoVRMPlugin.hide()


#func _on_download_completed_confirmed():
	#var path = OS.get_executable_path()
	#OS.execute(path, [], [], false)
	#get_tree().quit()


func _on_access_token_error_confirmed():
	self.hide()
	VRoidHub.start()



func _on_no_vrm_plugin_confirmed():
	self.hide()
	VRoidHub.remove()
	VRoidHub.start()


func _on_error_confirmed():
	self.hide()
