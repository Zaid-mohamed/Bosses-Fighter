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
