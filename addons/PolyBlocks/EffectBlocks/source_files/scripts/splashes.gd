extends GPUParticles3D

var can_activate = true
@export var auto_animate: bool = false
@export var cooldown_time = 1.0
@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var decal: Decal = $Decal

var decal_fade_time := 0.5
var light_duration := 0.5

func _ready():
	omni_light_3d.visible = false
	decal.visible = false
	decal.albedo_mix = 0.0

func _process(_delta):
	if auto_animate and can_activate:
		activate_effects()
	elif Input.is_action_just_pressed("ui_accept") and can_activate:
		activate_effects()

func activate_effects():
	can_activate = false

	decal.visible = false
	decal.albedo_mix = 0.0

	emitting = true

	await get_tree().create_timer(0.2).timeout
	show_decal_with_fade()
	omni_light_3d.visible = true

	await get_tree().create_timer(light_duration).timeout
	omni_light_3d.visible = false

	var timer = get_tree().create_timer(cooldown_time)
	timer.timeout.connect(_on_cooldown_timeout)

func _on_cooldown_timeout():
	can_activate = true

func show_decal_with_fade():
	decal.visible = true
	var t := 0.0
	while t < decal_fade_time:
		var mix := t / decal_fade_time
		decal.albedo_mix = mix
		await get_tree().process_frame
		t += get_process_delta_time()
	decal.albedo_mix = 1.0
