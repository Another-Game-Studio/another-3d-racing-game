extends Control

@onready var my_label : Label = $Label
#@export var car : JuicedCar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#var content_to_show : String = str(car.linear_velocity)+"\nPower:"+str(car.power)#+"Power: "+str(car.controls.power)+"\nSteering: "+str(car.controls.steering)
	#my_label.text = content_to_show
