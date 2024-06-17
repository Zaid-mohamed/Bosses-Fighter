extends Area2D
## the hurtbox of that take damage and detect hitboxes
class_name HurtBox

# it has an actor that own it
@export var actor : CharacterBody2D
# and need a health to use it
@export var health : Health

# when a hit box enters
func _on_area_entered(hit_box: HitBox) -> void:
	# make the given health take given damage amount (of the hitbox)
	health.take_damage(hit_box.damage_amount)
	
