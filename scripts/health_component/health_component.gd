class_name Health extends Node


# the inital health value, the max health
@export var max_health : int
# the character body that have this health
@export var actor : CharacterBody2D

# the current health that the actor has
var health : int :
	set(value):
		# when the health change, clamp the new value between 0 and the max health
		health = clamp(value, 0, max_health)
		# if the health = 0
		if health == 0:
			# emit the died signal
			died.emit()


# emited when taking damage
signal took_damage (amount : int)
# emited when healed
signal healed (amount : int)
# emited when health = 0
signal died

func _ready() -> void:
	# set the health to the max_health in beginning
	health = max_health



func take_damage(amount : int):
	# decrease the health by the given damage amount
	health -= amount
	# emit the tool_damage signal passing the damage
	took_damage.emit(amount)
	$"../Controls".health_edited.emit(health)


func heal(amount : int):
	# increase the health with the given amount
	health += amount
	# emit the healed passing the amount
	healed.emit(amount)


