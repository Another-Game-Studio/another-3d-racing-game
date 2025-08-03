extends Button

@onready var main_menu_scene: PackedScene = preload("res://menus/main_menu.tscn")

func _ready() -> void:
	button_down.connect(_on_return_to_main_menu)
	
func _on_return_to_main_menu() -> void:
	GameData.number_of_coins_at_game_over = 0
	get_tree().change_scene_to_packed(main_menu_scene)