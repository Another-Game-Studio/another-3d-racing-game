extends Label

func _ready() -> void:
	GameData.score_ready.connect(_update_score)
	_update_score()

func _update_score() -> void:
	text = "Score : " + str(GameData.number_of_coins_at_game_over)
