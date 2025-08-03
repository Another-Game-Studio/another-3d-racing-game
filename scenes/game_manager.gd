extends Node

@export var coin_label: Label
@export var heart_sprites: Array[Sprite2D]
@export var heart_full: Texture2D
@export var heart_empty: Texture2D
@export var coin_sound: AudioStream
@export var damage_sound: AudioStream

var coin_count: int = 0
var life: int = 4

@onready var coin_player: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var damage_player: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var game_over_scene: PackedScene = preload("res://scenes/gameover.tscn")

func _ready() -> void:
	coin_player.volume_db = linear_to_db(0.5)
	damage_player.volume_db = linear_to_db(0.5)
	add_child(coin_player)
	add_child(damage_player)
	SignalBus.coin_collected.connect(_on_coin_collected)
	SignalBus.car_fell.connect(_on_car_fell)
	_update_label()
	_update_hearts()

func _on_coin_collected() -> void:
	coin_count += 1
	_update_label()
	if coin_sound:
		coin_player.stream = coin_sound
		coin_player.play()

func lose_life() -> void:
	life -= 1
	life = max(life, 0)
	_update_hearts()
	if damage_sound:
		damage_player.stream = damage_sound
		damage_player.play()
		
	if life == 0:	
		SignalBus.lose_life.emit(life, coin_count)
		await get_tree().process_frame
		get_tree().change_scene_to_packed(game_over_scene)

func _update_label() -> void:
	if coin_label:
		coin_label.text = str(coin_count)

func _update_hearts() -> void:
	for i: int in heart_sprites.size():
		if i < life:
			heart_sprites[i].texture = heart_full
		else:
			heart_sprites[i].texture = heart_empty
			
func _on_car_fell() -> void:
	SignalBus.lose_life.emit(0, coin_count)
	await get_tree().process_frame
	get_tree().change_scene_to_packed(game_over_scene)
	
