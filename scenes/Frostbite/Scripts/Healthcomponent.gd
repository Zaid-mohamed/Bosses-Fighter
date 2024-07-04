extends Node

## Health Variables
@export var max_health : int = 320
var current_health : int

## Signals I Explained it Below >><<
signal decide
signal died
signal took_damage(amount: int)

func _ready():
	current_health = max_health

func take_damage(amount: int):
	## Take The Damage
	current_health -= amount
	
	## This Signal Conntected in <<Frostbite.gd>>
	emit_signal("took_damage", amount)
	
	## If the Health < Or = 0, The Boss will Die
	if current_health <= 0:
		current_health = 0
		## This Signal Connected in <<Frostbite.gd>>
		emit_signal("died")
	
	## Else: Change to Decide State.
	else:
		emit_signal("decide")
