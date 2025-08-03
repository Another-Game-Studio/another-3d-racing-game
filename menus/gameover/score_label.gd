extends Label

func _ready() -> void:
	text = "Score : " + str(GameData.number_of_coins_at_game_over)
