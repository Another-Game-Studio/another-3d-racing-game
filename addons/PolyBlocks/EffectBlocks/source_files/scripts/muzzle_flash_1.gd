extends Node3D

@onready var animated_flash_1: AnimatedSprite3D = $AnimatedFlash_1
@onready var animated_flash_2: AnimatedSprite3D = $AnimatedFlash_2
@onready var omni_light: OmniLight3D = $OmniLight
@onready var smoke: GPUParticles3D = $Smoke
@onready var sparks: GPUParticles3D = $Sparks
@onready var bullets: GPUParticles3D = $Bullets

@export var flash_duration = 0.05
const NUM_FRAMES = 4

func _ready():
	hide_effects()

func muzzle_flash():
	var random_frame = randi() % NUM_FRAMES
	animated_flash_1.frame = random_frame
	animated_flash_2.frame = random_frame
	
	show_effects()
	
	var hide_timer = get_tree().create_timer(flash_duration)
	hide_timer.timeout.connect(hide_effects)

func show_effects():
	animated_flash_1.visible = true
	animated_flash_2.visible = true
	omni_light.visible = true
	smoke.emitting = true
	sparks.emitting = true
	bullets.emitting = true

func hide_effects():
	animated_flash_1.visible = false
	animated_flash_2.visible = false
	omni_light.visible = false
