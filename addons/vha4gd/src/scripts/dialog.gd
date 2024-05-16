extends Control

func _ready():
	self.hide()

func download_completed_dialog():
	self.show()
	$DownloadCompleted.popup_centered()
	
func access_token_error_dialog():
	self.show()
	$AccessTokenError.popup_centered()

func no_vrm_plugin_dialog():
	self.show()
	$NoVRMPlugin.popup_centered()
	
func remove_dialog():
	self.hide()
	$DownloadCompleted.hide()
	$AccessTokenError.hide()
	$NoVRMPlugin.hide()


func _on_download_completed_confirmed():
	var path = OS.get_executable_path()
	OS.execute(path, [], [], false)
	get_tree().quit()


func _on_access_token_error_confirmed():
	VRoidHub.start()

