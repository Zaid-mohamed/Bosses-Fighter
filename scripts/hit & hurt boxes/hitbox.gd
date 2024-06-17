extends Area2D
class_name HitBox

# the damage amount of this hitbx
@export var damage_amount : int
# the damage class for this hitbox
var damage : Damage = Damage.new()

func _ready() -> void:
	#when ready, update the damage class amount, to the damage amount of the hitboc 
	damage.amount = damage_amount



# when a hurtbox enters (this function is useless I will complete it later)
func _on_area_entered(area: HurtBox) -> void:
	var direction_to_body = global_position.direction_to(area.global_position)
	damage.knock_back_vector = direction_to_body
