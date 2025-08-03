extends Node

var number_of_coins_at_game_over: int = 0

func _ready() -> void:
	SignalBus.lose_life.connect(_on_lose_life)
	

func _on_lose_life(life_left: int, number_of_coins: int) -> void:
	if life_left == 0:
		number_of_coins_at_game_over = number_of_coins
		