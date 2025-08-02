extends Camera3D

@export var move_speed: float = 5.0
@export var speed_multiplier: float = 3.0
@export var mouse_sensitivity: float = 0.005
@export var max_pitch: float = 1.5
@export var min_pitch: float = -1.5

var rotation_h: float = 0.0
var rotation_v: float = 0.0
var is_mouse_captured: bool = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_mouse_capture()
		return
	
	if not is_mouse_captured:
		return
		
	if event is InputEventMouseMotion:
		rotation_h -= event.relative.x * mouse_sensitivity
		rotation_v -= event.relative.y * mouse_sensitivity
		rotation_v = clamp(rotation_v, min_pitch, max_pitch)
		
		transform.basis = Basis()
		rotate_object_local(Vector3.UP, rotation_h)
		rotate_object_local(Vector3.RIGHT, rotation_v)

func _process(delta):
	if not is_mouse_captured:
		return
		
	var input_dir = get_input_direction()
	if input_dir.length() == 0:
		return
	
	var current_speed = move_speed
	if Input.is_action_pressed("shift"):
		current_speed *= speed_multiplier
	
	var movement = transform.basis * input_dir.normalized() * current_speed * delta
	var new_position = transform.origin + movement
	
	new_position.x = clamp(new_position.x, -10.0, 50.0)
	new_position.y = clamp(new_position.y, 1.0, 15.0)
	new_position.z = clamp(new_position.z, -15.0, 15.0)
	
	transform.origin = new_position

func toggle_mouse_capture():
	is_mouse_captured = not is_mouse_captured
	
	if is_mouse_captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func get_input_direction() -> Vector3:
	var input_dir = Vector3.ZERO
	
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("w"):
		input_dir.z -= 1
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("s"):
		input_dir.z += 1
	
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("a"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("d"):
		input_dir.x += 1
	
	if Input.is_action_pressed("q"):
		input_dir.y += 1
	if Input.is_action_pressed("e"):
		input_dir.y -= 1
	
	return input_dir
