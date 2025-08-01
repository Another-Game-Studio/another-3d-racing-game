extends MeshInstance3D

enum BackfireDirection {
	NEGATIVE_X,
	POSITIVE_X,
	NEGATIVE_Y,
	POSITIVE_Y,
	NEGATIVE_Z,
	POSITIVE_Z
}

@export var muzzle_flash: Node3D
@export var auto_animate: bool = false
@export var backfire_direction: BackfireDirection = BackfireDirection.NEGATIVE_Z
@export var distance = 0.02
@export var duration = 0.05
@export var cooldown = 0.1

var is_backfiring = false
var backfire_timer = 0.0
var cooldown_timer = 0.0
var is_on_cooldown = false
var original_position = Vector3.ZERO
var backfire_position = Vector3.ZERO

func _ready():
	original_position = position
	
	# Start auto animation immediately if enabled
	if auto_animate:
		start_animation()

func _process(delta):
	if is_on_cooldown:
		cooldown_timer += delta
		if cooldown_timer >= cooldown:
			is_on_cooldown = false
			cooldown_timer = 0.0
			
			# Auto animate after cooldown if enabled
			if auto_animate and not is_backfiring:
				start_animation()
	
	# Manual trigger (only when auto_animate is disabled)
	if not auto_animate and Input.is_action_just_pressed("ui_select") and not is_backfiring and not is_on_cooldown:
		start_animation()
	
	if is_backfiring:
		backfire_timer += delta
		
		if backfire_timer <= duration / 2:
			var t = backfire_timer / (duration / 2)
			position = original_position.lerp(backfire_position, t)
		elif backfire_timer <= duration:
			var t = (backfire_timer - duration / 2) / (duration / 2)
			position = backfire_position.lerp(original_position, t)
		else:
			position = original_position
			is_backfiring = false
			backfire_timer = 0.0
			
			start_cooldown()

func start_animation():
	muzzle_flash.muzzle_flash()
	is_backfiring = true
	backfire_timer = 0.0
	
	var direction_vector = get_direction_vector()
	backfire_position = original_position + direction_vector * distance

func get_direction_vector() -> Vector3:
	match backfire_direction:
		BackfireDirection.NEGATIVE_X:
			return -Vector3.RIGHT
		BackfireDirection.POSITIVE_X:
			return Vector3.RIGHT
		BackfireDirection.NEGATIVE_Y:
			return -Vector3.UP
		BackfireDirection.POSITIVE_Y:
			return Vector3.UP
		BackfireDirection.NEGATIVE_Z:
			return -Vector3.FORWARD
		BackfireDirection.POSITIVE_Z:
			return Vector3.FORWARD
		_:
			return -Vector3.FORWARD

func start_cooldown():
	is_on_cooldown = true
	cooldown_timer = 0.0
