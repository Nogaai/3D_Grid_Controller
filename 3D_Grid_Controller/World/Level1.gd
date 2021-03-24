extends Spatial


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
