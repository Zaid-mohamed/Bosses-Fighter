extends Area2D

@export var speed = 3
@export var damage_strength : int = 1
var shooter : Node2D = null
var damage_enemies = false

func _physics_process(delta):
	$Sprite2D.rotation_degrees = -rotation_degrees
	position += Vector2(speed * Engine.time_scale,0).rotated(rotation)

func _on_body_entered(body):
	if body == shooter:
		return
	
	if body.is_in_group("Player") && body.is_in_group("Damageable"):
		# body.damage(damage_strength,knock_strength,(body.position - position).angle())
		break_snowball()
	else:
		break_snowball()

func break_snowball():
	$Sprite2D.hide()
	$CollisionShape2D.set_deferred("disabled",true)
	speed = 0
	$Destroy.restart()
	await get_tree().create_timer(0.25).timeout
	queue_free()
