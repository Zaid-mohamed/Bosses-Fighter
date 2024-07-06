extends CharacterBody2D
class_name DeekFireBall
@export var speed: float

func _physics_process(delta: float) -> void:
	move_and_collide(velocity)
