##Based on https://www.youtube.com/watch?v=QUQ8_vcu64o

##Deprecated, utiliser la Car qui extend de RigidBody
extends VehicleBody3D
class_name Car

const max_torque : int = 500
const max_RPM : int = 450
const turn_speed : float = 3.0
const turn_amount : float = 0.3

const jump_force : float = 50.0

@export var controls : PlayerController

@export var camera_controller : Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	

	var power : float = controls.power
	var direction : float = controls.steering
	var RPM_left : float = abs($wheel_back_left.get_rpm())
	var RPM_right : float = abs($wheel_back_right.get_rpm())
	var RPM : float = (RPM_left+RPM_right)/2.0
	var torque : float = power * max_torque * (1.0-RPM/max_RPM)
	engine_force = torque
	steering = lerp(steering, direction*turn_amount, turn_speed*delta)
	if controls.jump and $wheel_back_left.is_in_contact() and $wheel_back_right.is_in_contact():
		apply_central_impulse(Vector3.UP*jump_force)

	#Make camera controller match the position of the car
	camera_controller.position = lerp(camera_controller.position, position, 0.1)
	camera_controller.rotation = rotation
	if controls.brake or controls.rearview:
		camera_controller.rotation.y +=PI

