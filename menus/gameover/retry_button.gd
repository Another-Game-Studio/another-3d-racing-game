extends Button

@onready var level_scene: PackedScene = load("res://scenes/art_tests.tscn")

func _ready() -> void:
	button_down.connect(_on_retry_game)
	
func _on_retry_game() -> void:
	GameData.number_of_coins_at_game_over = 0
	get_tree().change_scene_to_packed(level_scene)