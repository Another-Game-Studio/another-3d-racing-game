extends Node3D

@onready var effect_1: GPUParticles3D = $Effect1
@onready var effect_2: GPUParticles3D = $Effect2
@onready var light: OmniLight3D = $Light

@export var auto_animate: bool = false
@export var cooldown_time = 2.0
@export var light_fade_time = 0.5

var can_activate = true

func _ready():
	light.light_energy = 0
	if auto_animate:
		_auto_trigger_effects()

func _process(_delta):
	if not auto_animate and Input.is_action_just_pressed("ui_accept") and can_activate:
		activate_effects()

func activate_effects():
	can_activate = false

	# Start particle emission
	effect_1.emitting = true
	effect_2.emitting = true

	# Set light energy and start fade tween
	light.light_energy = 3.0
	var tween = create_tween()
	tween.tween_property(light, "light_energy", 0.0, light_fade_time)

	# Start cooldown timer
	var timer = get_tree().create_timer(cooldown_time)
	timer.timeout.connect(_on_cooldown_timeout)

func _on_cooldown_timeout():
	can_activate = true
	if auto_animate:
		activate_effects()

func _auto_trigger_effects():
	if can_activate:
		activate_effects()
