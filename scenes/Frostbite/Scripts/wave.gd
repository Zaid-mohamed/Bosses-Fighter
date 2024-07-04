extends Area2D

var direction : Vector2

@export var speed = 5

func _physics_process(delta: float) -> void:
	position += direction * speed
