@tool
extends EditorPlugin 

const CamPreview = preload("./cam_preview.tscn")
const PreviewButton = preload("./preview_button.tscn")
var cam_preview_instance
var button_instance

var _visible : bool = false

var cam_selected: Camera3D
var pcam: Camera3D
var rt: RemoteTransform3D

var eds = get_editor_interface().get_selection()

func _enter_tree():
	main_screen_changed.connect(_main_screen_changed)
	
	cam_preview_instance = CamPreview.instantiate()
	
	get_editor_interface().add_child(cam_preview_instance)
	cam_preview_instance.toggle_window(false)
	cam_preview_instance.toggle_window(_visible)
	
	button_instance = PreviewButton.instantiate()
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, button_instance)
	
	button_instance.preview_toggled.connect(preview_pressed)
	button_instance.preview_clear.connect(preview_free)
	
	eds.selection_changed.connect(selection_changed)

func _process(_delta):
	if cam_selected != null and pcam != null:
		store_properties()

func store_properties():
	pcam.fov = cam_selected.fov
	pcam.projection = cam_selected.projection
	pcam.size = cam_selected.size

func _exit_tree():
	main_screen_changed.disconnect(_main_screen_changed)
	
	if button_instance.preview_clear.is_connected(preview_free):
		button_instance.preview_clear.disconnect(preview_free)
	if button_instance.preview_toggled.is_connected(preview_pressed):
		button_instance.preview_toggled.disconnect(preview_pressed)
	
	preview_free()
	if cam_preview_instance:
		cam_preview_instance.queue_free()
	if button_instance:
		button_instance.queue_free()

func find_a_camera(root) -> Camera3D:
	if root is Camera3D:
		return root
	match button_instance.search_mode:
		1:
			return root.find_node(button_instance.search_name, true, false) as Camera3D
		2:
			return get_cam_recursive(root)
	return null 
	
func get_cam_recursive(root):
	var cam: Camera3D
	for child in root.get_children():
		if child is Camera3D:
			return child
		cam = get_cam_recursive(child)
	return cam

func selection_changed():
	var selected = eds.get_selected_nodes()
	
	if not selected.is_empty():
		var cam = find_a_camera(selected[0])
		if cam:
			if cam_selected:
				cam_selected.tree_exiting.disconnect(cam_deleted)
			cam_selected = cam
			#remove old camera and remote transform
			
			preview_free()
			pcam = Camera3D.new()
			
			rt = RemoteTransform3D.new()
			cam_preview_instance.get_vp().add_child(pcam)
			cam_preview_instance.toggle_vp(true)
			cam_preview_instance.toggle_window(_visible)
			cam.add_child(rt)
			cam.tree_exiting.connect(cam_deleted)
			rt.remote_path = pcam.get_path()
			rt.use_global_coordinates = true
			
			store_properties()
			

func cam_deleted():
	preview_free()
	cam_preview_instance.toggle_vp(false)
	
	if cam_selected.tree_exiting.is_connected(cam_deleted):
		cam_selected.tree_exiting.disconnect(cam_deleted)

func preview_free():
	if pcam != null:
		pcam.queue_free()
	if rt != null:
		rt.queue_free()
	cam_preview_instance.toggle_vp(false)

func show_all():
	if cam_preview_instance and _visible:
		cam_preview_instance.show()
	if button_instance:
		button_instance.show()

func hide_all():
	if cam_preview_instance:
		cam_preview_instance.hide()
	if button_instance:
		button_instance.hide()

func _main_screen_changed(screen):
	if screen == "3D":
		show_all()
	else:
		hide_all()

func preview_pressed(toggle):
	cam_preview_instance.toggle_window(toggle)
	_visible = toggle
