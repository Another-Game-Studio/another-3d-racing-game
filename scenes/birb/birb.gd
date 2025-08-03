extends CharacterBody3D
class_name Birb

@onready var droppoints : Array[Marker3D] = []

const coin_class : PackedScene = preload("res://scenes/collectibles/coin/Coin.tscn")

var can_drop : bool = false :
	set(new_value):
		can_drop = new_value
		if can_drop:
			$CoinDropTimer.start()
		else:
			$CoinDropTimer.stop()

## Le monde 3D dans lequel lâcher notre pièce
var world_3D : Node3D


func _ready() -> void:
	var droppoints_nodes : Array[Node] = $Droppoints.get_children()
	for droppoint_node : Node in droppoints_nodes:
		if droppoint_node is Marker3D:
			droppoints.append(droppoint_node as Marker3D)
	$CoinDropTimer.timeout.connect(_on_drop_timer_timeout)

func _on_drop_timer_timeout() -> void:
	drop_coin()
	$CoinDropTimer.start()

func drop_coin() -> void:
	var coin : RigidBody3D = coin_class.instantiate()
	coin.global_position = $Droppoints.get_random_droppoint()
	world_3D.add_child(coin)

func _physics_process(delta: float) -> void:
	pass
