extends Control

@onready var return_to_game_button: Button = %ReturnToGameButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	return_to_game_button.button_down.connect(_on_return_to_game)
	
func _on_return_to_game() -> void:	
	get_tree().paused = false
	visible = false