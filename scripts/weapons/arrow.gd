extends CharacterBody2D


# the speed of the arrow when spawned (it is used by the item node in the player scene)
@export var speed : float = 1000.0

# the item data of the bow
@export var item_data : ItemData

# the hitbox of the arrow
@onready var hitbox: HitBox = %Hitbox

func _ready() -> void:
	# when ready the knock_back_force of the hitbox will be the bow knock_back_force
	hitbox.knock_back_force = item_data.knock_back_force
func _physics_process(delta: float) -> void:
	# make the arrow look to the direction where he goes
	move_and_slide()
	rotation = velocity.angle()




# when hitbox leave the target
func _on_hitbox_area_exited(area: Area2D) -> void:
	# turn off the hitbox
	hitbox.get_child(0).set_deferred("disabled", true)
	# create the tween that will free the arrow
	var free_tween = create_tween()
	# make it parralel
	free_tween.parallel()
	# tween the scale to zero in 0.2 secs
	free_tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
	# tween the color to transparent in 0.2 secs
	free_tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
