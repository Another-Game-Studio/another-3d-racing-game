##Extension de CarController pour prendre en compte les inputs du joueur
extends CarController
class_name PlayerController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	power = Input.get_action_strength("gas") - Input.get_action_strength("brake")
	steering = Input.get_action_strength("left") - Input.get_action_strength("right")
	jump = Input.is_action_pressed("jump")
