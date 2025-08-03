extends Node3D

@onready var pause_menu: Control = %PauseMenu

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		pause_menu.visible = true
		