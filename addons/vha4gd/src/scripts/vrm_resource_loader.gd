# vrm_resource_loader.gd
extends ResourceFormatLoader

func _get_recognized_extensions():
	return ["vrm"]

func _load(path, original_path, use_sub_threads, cache_mode):
	var vrm_importer = load("res://addons/vha4gd/src/scripts/vrm_importer.gd").new()
	return vrm_importer.import_scene(path)
