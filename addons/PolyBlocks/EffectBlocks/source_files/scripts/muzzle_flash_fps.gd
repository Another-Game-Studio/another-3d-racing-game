extends MeshInstance3D

@onready var omni_light: OmniLight3D = $OmniLight3D
@onready var smoke: GPUParticles3D = $Smoke
@onready var sparks: GPUParticles3D = $Sparks


@export var flash_duration = 0.05
@export var cooldown_time = 2.0

var can_fire = true
var is_trigger_pressed = false
var is_trigger_released = true

func _ready():
	hide_effects()

func _process(_delta):
	is_trigger_pressed = Input.is_action_pressed("ui_select")
	
	if is_trigger_pressed and can_fire and is_trigger_released:
		fire()
		is_trigger_released = false
	
	if !is_trigger_pressed:
		is_trigger_released = true

func fire():
	muzzle_flash()
	
	can_fire = false
	var cooldown_timer = get_tree().create_timer(cooldown_time)
	cooldown_timer.timeout.connect(reset_cooldown)

func reset_cooldown():
	can_fire = true

func muzzle_flash():
	
	show_effects()
	
	var hide_timer = get_tree().create_timer(flash_duration)
	hide_timer.timeout.connect(hide_effects)

func show_effects():
	self.visible = true
	omni_light.visible = true
	smoke.emitting = true
	sparks.emitting = true

func hide_effects():
	self.visible = false
	omni_light.visible = false
