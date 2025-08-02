extends Node

@export var coin_label: Label
var coin_count: int = 0

func _ready() -> void:
	SignalBus.coin_collected.connect(_on_coin_collected)
	_update_label()

func _on_coin_collected() -> void:
	coin_count += 1
	_update_label()

func _update_label() -> void:
	if coin_label:
		coin_label.text = str(coin_count)
