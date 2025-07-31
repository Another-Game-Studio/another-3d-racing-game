extends RayCast3D
class_name RayCastWheel

@export var spring_strength : float = 100.0
@export var spring_damp : float = 20.0
@export var rest_position : float = 0.5

@export var overextend : float = 0.0

@export var wheel_radius : float = 0.25

@export var is_motor : bool = false

@onready var wheel : MeshInstance3D = $Wheel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
