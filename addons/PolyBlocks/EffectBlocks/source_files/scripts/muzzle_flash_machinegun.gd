extends Node3D

@onready var animated_flash_1: AnimatedSprite3D = $AnimatedFlash_1
@onready var animated_flash_2: AnimatedSprite3D = $AnimatedFlash_2
@onready var omni_light: OmniLight3D = $OmniLight
@onready var smoke: GPUParticles3D = $Smoke
@onready var sparks: GPUParticles3D = $Sparks
@onready var bullets: GPUParticles3D = $Bullets

const NUM_FRAMES = 4
@export var flash_duration = 0.05
@export var cooldown_duration = 0.1
var can_fire = true
var fire_timer = null
var is_firing = false

func _ready():
	hide_flash_effects()
	
func _process(_delta):
	is_firing = Input.is_action_pressed("ui_select")
	
	if is_firing:
		smoke.emitting = true
		sparks.emitting = true
		bullets.emitting = true
		
		if can_fire:
			muzzle_flash()
	else:
		stop_all_effects()

func muzzle_flash():
	can_fire = false
	
	var random_frame = randi() % NUM_FRAMES
	
	animated_flash_1.frame = random_frame
	animated_flash_2.frame = random_frame
	
	animated_flash_1.visible = true
	animated_flash_2.visible = true
	omni_light.visible = true
	
	var hide_timer = get_tree().create_timer(flash_duration)
	hide_timer.timeout.connect(hide_flash_effects)
	
	fire_timer = get_tree().create_timer(flash_duration + cooldown_duration)
	fire_timer.timeout.connect(reset_fire_cooldown)

func hide_flash_effects():
	animated_flash_1.visible = false
	animated_flash_2.visible = false
	omni_light.visible = false

func stop_all_effects():
	hide_flash_effects()
	smoke.emitting = false
	sparks.emitting = false
	bullets.emitting = false

func reset_fire_cooldown():
	can_fire = true
