@tool
extends Window

@onready var control : Control = $Control
@onready var vp: SubViewport = $Control/container/vp
@onready var container: SubViewportContainer = $Control/container


func _process(delta):
	vp.size = control.size


func get_vp() -> SubViewport:
	return vp

func toggle_window(toggle):
	visible = toggle

func toggle_vp(toggle):
	container.visible = toggle

func close_request():
	toggle_window(false)
