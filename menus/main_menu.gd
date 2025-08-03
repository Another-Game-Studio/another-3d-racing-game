extends Control

@onready var new_game_button: Button = %NewGameButton
@onready var options_button: Button = %OptionsButton
@onready var credits_button: Button = %CreditsButton
@onready var exit_button: Button = %ExitButton

@onready var credits_scene: PackedScene = preload("res://scenes/credits.tscn")
@onready var options_scene: PackedScene = preload("res://scenes/options.tscn")

func _ready() -> void:
	new_game_button.button_down.connect(_on_new_game_button_down)
	options_button.button_down.connect(_on_options_button_down)
	credits_button.button_down.connect(_on_credits_button_down)
	exit_button.button_down.connect(_on_exit_button_down)

func _on_new_game_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/art_tests.tscn")

func _on_options_button_down() -> void:
	get_tree().change_scene_to_packed(options_scene)

func _on_credits_button_down() -> void:
	get_tree().change_scene_to_packed(credits_scene)

func _on_exit_button_down() -> void:
	get_tree().quit()	
