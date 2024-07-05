class_name FrostbiteMinion extends CharacterBody2D

@export var speed: float = 50
@onready var player = get_parent().get_node("player")

func _process(delta):
	move_toward_player(delta)

func  move_toward_player(delta):
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
