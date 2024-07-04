## This is the Hitbox, Like Sword, Bow, Other.
## But in the frostbite i won't use it, i made simple one in <<Frostbite.gd>>
extends Area2D

@export var damage: int = 10

## I Used this in the signal <<hit>> in <<Hurtbox.gd>>
func get_damage_amount() -> int:
	return damage

## THIS IS A TEMP CODE, I'LL DELETE IT IN THE MAIN BRANCH
