## Classe permettant de séparer l'input du joueur du script de la voiture. Toutes les classes permettant de contrôler la voiture doivent hériter de cette classe-là.
## Peut être étendue pour ajouter des joueurs IA ou des inputs enregistrées/autres
extends Node
class_name CarController

var power : float ##Gas minus brake
var steering : float ##Steering, left minus right
var jump : bool = false

var brake : bool = false
var rearview : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
