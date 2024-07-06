extends Area2D

var direction : Vector2

@export var speed = 100

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is TileMap:
		queue_free()
