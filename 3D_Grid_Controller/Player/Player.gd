extends KinematicBody

onready var Grid = get_parent()
onready var camera = $Camera
export var walk_speed : float = 1
export var mouse_sensitivity = .002
onready var move = $Tween

func _ready():	
	pass

func _process(delta):
	handle_movement()
	
func handle_movement():
	var input_direction = get_input_direction()
	# if the player isn't trying to move - do nothing
	if not input_direction:
		return
	# Ask the Grid parent what's in the target cell
	var target_position = Grid.request_move(self, input_direction)
	# If target_position is a vector - move to the position
	if target_position is Vector3:
		move_to(target_position)

func get_input_direction():
	var input_dir = Vector3()
	if Input.is_action_just_pressed("forward"):
		input_dir = -camera.global_transform.basis.z
	if Input.is_action_just_pressed("backward"):
		input_dir = camera.global_transform.basis.z
	if Input.is_action_just_pressed("left"):
		input_dir = -camera.global_transform.basis.x
	if Input.is_action_just_pressed("right"):
		input_dir = camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir.round()

func move_to(target_position):
	set_process(false)
	var starting_position = translation
	move.interpolate_property(self, "translation", starting_position, target_position, walk_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	move.start()
	
	yield(move, "tween_completed")
	
	set_process(true)

# Catch all mouse movement and apply to camera rotation
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		# Clamp look so that you cant try to only move up or down
		camera.rotation.x = clamp(camera.rotation.x, -1, 1)
	pass # Replace with function body.
