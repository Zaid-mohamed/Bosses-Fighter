extends Area2D

## The Damage that Hurtbox's Owner will take.
## Signal with Name hit that takes parameter <<Damage>>.
signal hit(damage: int)

func _on_body_entered(body):
	## if the body has ability or permission to attack the Hurtbox's Owner.
	## Hurtbox's Owner will Take the Damage Amount
	if body.has_method("get_damage_amount"): ## <<get_damage_amount>> locates in <<Hitbox.gd>>
		emit_signal("hit", body.get_damage_amount()) ## Emits Signal in The Main Scripts <<Frostbite.gd>>
