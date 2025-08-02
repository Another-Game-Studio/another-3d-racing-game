extends CharacterBody3D
class_name Birb

@onready var droppoints : Array[Marker3D] = []

func _ready() -> void:
	var droppoints_nodes : Array[Node] = $Droppoints.get_children()
	for droppoint_node : Node in droppoints_nodes:
		if droppoint_node is Marker3D:
			droppoints.append(droppoint_node as Marker3D)

func _physics_process(delta: float) -> void:
	pass
