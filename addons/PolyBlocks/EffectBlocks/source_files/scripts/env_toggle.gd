extends Node3D

@onready var world_environment = $WorldEnvironment

func _ready():
	world_environment.environment.volumetric_fog_enabled = true

func _process(_delta):
	if Input.is_action_just_pressed("f"):
		toggle_fog()

func toggle_fog():
	world_environment.environment.volumetric_fog_enabled = !world_environment.environment.volumetric_fog_enabled
