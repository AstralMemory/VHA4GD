# vrm_importer.gd
extends Resource
class_name VRMImporter

var gltf_document_extension_class

func _init():
	register_vrm_loader()
	if FileAccess.file_exists("res://addons/vrm/vrm_extension.gd"):
		gltf_document_extension_class = load("res://addons/vrm/vrm_extension.gd")
	else:
		Dialog.no_vrm_plugin_dialog()

func register_vrm_loader():
	var vrm_loader = load("res://addons/vha4gd/src/scripts/vrm_resource_loader.gd").new()
	ResourceLoader.add_resource_format_loader(vrm_loader)

func import_scene(path: String) -> Object:
	print("Import VRM: " + path + " ----------------------")
	var gltf: GLTFDocument = GLTFDocument.new()
	if gltf_document_extension_class == null:
		Dialog.no_vrm_plugin_dialog()
		return
	var vrm_extension: GLTFDocumentExtension = gltf_document_extension_class.new()
	gltf.register_gltf_document_extension(vrm_extension, true)
	var state: GLTFState = GLTFState.new()
	state.use_named_skin_binds = true
	state.handle_binary_image = GLTFState.HANDLE_BINARY_EMBED_AS_UNCOMPRESSED
	var err = gltf.append_from_file(path, state, 8)
	if err != OK:
		gltf.unregister_gltf_document_extension(vrm_extension)
		return null
	var generated_scene = gltf.generate_scene(state)
	gltf.unregister_gltf_document_extension(vrm_extension)
	return generated_scene
