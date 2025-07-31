extends SpringArm3D

var mouse_sensitivity : float = 0.1
var joystick_sensitivity : float = 1.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#set_as_top_level(true)


func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, -10.0)
		
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)

func get_joystick_controls(delta: float) -> void:
	rotation_degrees.x -= (Input.get_action_strength("cam_down") - Input.get_action_strength("cam_up")) * joystick_sensitivity
	rotation_degrees.x = clamp(rotation_degrees.x, -90.0, -10.0)
	
	#rotation_degrees.y -= (Input.get_action_strength("cam_left") - Input.get_action_strength("cam_right")) * joystick_sensitivity
	#rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)

func _process(delta: float) -> void:
	get_joystick_controls(delta)
