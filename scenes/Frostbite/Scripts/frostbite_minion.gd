class_name FrostbiteMinion extends CharacterBody2D

@export var speed: float = 5
@export var current_speed: float = 5

@onready var player = get_parent().get_node("player")
@onready var dash_timer: Timer = $Dash_timer
@onready var hurt_box_collision: CollisionShape2D = $HurtBox/CollisionShape2D

# Dash variables
@export var dash_speed: float = 500

func _ready():
	current_speed = speed
	hurt_box_collision.disabled = true

func _process(delta):
	move_toward_player(delta)
	
	#if dash_timer.timeout:
		#await get_tree().create_timer(3)
		#hurt_box_collision.disabled = false
	
	print(current_speed)

func  move_toward_player(delta):
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * current_speed
	move_and_slide()

func _on_hurt_box_body_entered(body):
	current_speed = dash_speed
	dash_timer.start()

func _on_dash_timer_timeout():
	current_speed = speed
	hurt_box_collision.disabled = true

func _on_dash_cool_down_timer_timeout():
	hurt_box_collision.disabled = false
