extends Node

@export var coin_label: Label
@export var heart_sprites: Array[Sprite2D]
@export var heart_empty: Texture2D

var coin_count: int = 0
var life: int = 4

func _ready() -> void:
	SignalBus.coin_collected.connect(_on_coin_collected)
	_update_label()
	_update_hearts()

func _on_coin_collected() -> void:
	coin_count += 1
	_update_label()

func lose_life() -> void:
	life -= 1
	life = max(life, 0)
	_update_hearts()

func _update_label() -> void:
	if coin_label:
		coin_label.text = str(coin_count)

func _update_hearts() -> void:
	for i: int in heart_sprites.size():
		if i >= life:
			heart_sprites[i].texture = heart_empty
