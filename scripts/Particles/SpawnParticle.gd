extends GPUParticles2D

@export var target : Node2D
@export var scene_to_spawn : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	restart()
	await get_tree().create_timer(lifetime).timeout
	if scene_to_spawn:
		var entity = scene_to_spawn.instantiate()
		entity.position = position
		if target:
			entity.target = target
		get_parent().call_deferred("add_child",entity)
	if get_tree().get_nodes_in_group("SpawnParticle").size() >= 1 && get_tree().get_nodes_in_group("SpawnParticle")[0] == self:
		$"1".play()
	await get_tree().create_timer($EndParticle.lifetime).timeout
	queue_free()
	pass # Replace with function body.
