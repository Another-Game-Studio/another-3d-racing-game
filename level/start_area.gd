extends Area3D

@onready var player_spawn: Marker3D = %PlayerSpawn
@onready var player_scene: PackedScene = preload("res://scenes/car/car.tscn")


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	var player: Car = player_scene.instantiate()
	player.global_transform = player_spawn.transform
	add_child(player)
	
	
func _on_area_entered(player: Car) -> void:	
	SignalBus.player_entered_start_area.emit(player)
