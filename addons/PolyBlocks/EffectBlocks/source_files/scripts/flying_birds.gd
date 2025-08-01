extends MeshInstance3D

var upstroke_value: float = 0.0
var downstroke_value: float = 0.0
var is_upstroke_increasing: bool = true
var is_downstroke_increasing: bool = false
var soaring: bool = false
var soar_timer: float = 0.0
var wing_cycle_counter: int = 0

@export var wing_flap_speed: float = 2.0
@export var wing_cycles_before_soar: int = 3
@export var soar_duration: float = 1.5

@export var circle_center: Vector3 = Vector3.ZERO
@export var circle_radius: float = 10.0
@export var circle_height: float = 5.0
@export var flight_speed: float = 2.0

var current_angle: float = 0.0

func _ready() -> void:
	current_angle = randf() * 2 * PI

func _process(delta: float) -> void:
	animate_wings(delta)
	update_flight_path(delta)

func animate_wings(delta: float) -> void:
	if not soaring:
		if is_upstroke_increasing:
			upstroke_value += wing_flap_speed * delta
			if upstroke_value >= 1.0:
				upstroke_value = 1.0
				is_upstroke_increasing = false
		else:
			upstroke_value -= wing_flap_speed * delta
			if upstroke_value <= 0.0:
				upstroke_value = 0.0
				is_upstroke_increasing = true
		
		if is_downstroke_increasing:
			downstroke_value += wing_flap_speed * delta
			if downstroke_value >= 1.0:
				downstroke_value = 1.0
				is_downstroke_increasing = false
		else:
			downstroke_value -= wing_flap_speed * delta
			if downstroke_value <= 0.0:
				downstroke_value = 0.0
				is_downstroke_increasing = true
				
				wing_cycle_counter += 1
				if wing_cycle_counter >= wing_cycles_before_soar:
					soaring = true
					wing_cycle_counter = 0
					soar_timer = 0.0
	else:
		soar_timer += delta
		if soar_timer >= soar_duration:
			soaring = false
			is_upstroke_increasing = true
			is_downstroke_increasing = false
	
	set("blend_shapes/Upstroke", upstroke_value)
	set("blend_shapes/Downstroke", downstroke_value)

func update_flight_path(delta: float) -> void:
	current_angle += flight_speed * delta / circle_radius
	
	var new_position = circle_center + Vector3(
		circle_radius * cos(current_angle),
		circle_height,
		circle_radius * sin(current_angle)
	)
	
	global_position = new_position
	

	var forward_direction = Vector3(-sin(current_angle), 0, cos(current_angle)).normalized()
	look_at(global_position - forward_direction, Vector3.UP)
