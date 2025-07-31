## Classe permettant de séparer l'input du joueur du script de la voiture. Toutes les classes permettant de contrôler la voiture doivent hériter de cette classe-là.
## Peut être étendue pour ajouter des joueurs IA ou des inputs enregistrées/autres
extends Node
class_name CarController

var power : float ##Gas minus brake
var steering : float ##Steering, left minus right
var jump : bool = false