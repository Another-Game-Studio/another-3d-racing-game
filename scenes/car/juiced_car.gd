extends RigidBody3D
class_name JuicedCar

@export var wheels : Array[RayCastWheel]
@export var acceleration : float = 100.0

@export var decceleration : float = 200.0

@onready var controller : PlayerController = $PlayerController

@export var max_speed : float = 20.0

var power : float = 0.0
##Applique les suspensions sur les roues.
## Force = (ForceRessort*DistortionRessort) - (ForceDamping*VitesseRelative)
func _do_single_wheel_suspension(ray : RayCastWheel) -> void:
	if ray.is_colliding():
		ray.target_position.y = -(ray.rest_position+ray.wheel_radius+ray.overextend)
		var contact : Vector3 = ray.get_collision_point()
		var spring_up_direction : Vector3 = ray.global_transform.basis.y
		var spring_length : float = ray.global_position.distance_to(contact) - ray.wheel_radius
		var offset : float = ray.rest_position - spring_length
		
		ray.wheel.position.y = -spring_length
		
		var spring_force : float = ray.spring_strength * offset
		
		var world_velocity : Vector3 = _get_point_velocity(contact)
		var relative_velocity : float = spring_up_direction.dot(world_velocity)
		var spring_damping_force : float = ray.spring_damp * relative_velocity
		
		var force_vector : Vector3 = (spring_force - spring_damping_force) * spring_up_direction
		var force_position_offset : Vector3 = ray.wheel.global_position - global_position
		apply_force(force_vector, force_position_offset)

func _do_single_wheel_acceleration(ray : RayCastWheel, power : float) -> void:
	
	#ray.wheel.rotate_x(-velocity*get_process_delta_time()*2*PI*ray.wheel_radius)
	if ray.is_colliding() and ray.is_motor and power:
		var forward_dir : Vector3 = ray.global_basis.z
		var velocity : float = forward_dir.dot(linear_velocity)
		var contact : Vector3 = ray.wheel.global_position
		var force_vector : Vector3 = forward_dir * acceleration * power
		var force_position : Vector3 = contact - global_position
		if abs(velocity) > max_speed:
			force_vector = force_vector*0.1
		if power:
			apply_force(force_vector, force_position)
		else:
			force_vector = global_basis.z * decceleration * signf(velocity)
			apply_force(force_vector, force_position)

func _get_point_velocity(point: Vector3) -> Vector3:
	return linear_velocity + angular_velocity.cross(point-global_position)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta : float) -> void:
	power = controller.power
	for wheel : RayCast3D in wheels:
		_do_single_wheel_suspension(wheel)
		_do_single_wheel_acceleration(wheel, power)
	print()
