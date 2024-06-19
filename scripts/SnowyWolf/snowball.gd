extends CharacterBody2D

class_name Snowball

func _physics_process(delta):
	move_and_slide()

func _on_hitbox_body_entered(body):
	pass
