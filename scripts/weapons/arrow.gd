extends CharacterBody2D


# the speed of the arrow when spawned (it is used by the item node in the player scene)
@export var speed : float = 1000.0



func _physics_process(delta: float) -> void:
	# make the arrow look to the direction where he goes
	move_and_slide()
	rotation = velocity.angle()
