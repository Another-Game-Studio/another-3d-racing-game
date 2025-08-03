extends Button

func _ready() -> void:
	button_down.connect(_on_button_down)
	
func _on_button_down() -> void:	
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
