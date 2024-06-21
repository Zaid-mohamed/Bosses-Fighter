@tool
extends Area2D


# the item in the ground
@export var item_data : ItemData
# the distance when the item moves towards the player
@export var move_distance : float

# the sclae of speed of the moving when player is near
@export_range(0.0, 2.0)var speed_scale : float = 1.0
@onready var item_sprite: Sprite2D = %ItemSprite

@onready var player: Player = get_tree().get_first_node_in_group("player")
# the collision of the pick up item area2d
@onready var collision: CollisionShape2D = %Collision


func _ready() -> void:
	#when ready set the item_sprite texture to the item texture that this node carries
	item_sprite.texture = item_data.texture



func _process(delta: float) -> void:
	# if the distance the between the pick up and the player is less than the move distance
	if player.global_position.distance_to(global_position) < move_distance:
		# move towards the player multiplied by the speed scale
		global_position += global_position.direction_to(player.global_position) * speed_scale

func _on_body_entered(body: Node2D) -> void:
	# if the body is the player
	if body == player:
		# turn off any new detections
		collision.set_deferred("disabled", true)
		# create the tween that will be used to scale down node
		var scale_down_tween = create_tween()
		# scale down the node to zero, in 0.1 secs
		scale_down_tween.tween_property(self, "scale", Vector2.ZERO, 0.3)
		# wait until the tween finishes
		await scale_down_tween.finished
		# add the item to the player inventory if the hotbar is full,
		# else add item to the horbar
		if player.hotbar.inventory_data.is_full():
			player.inventory_dialog.inventory_data.add_item(item_data)
			# update the UI
			player.inventory_dialog.update_inventory_dialog()
		else:
			# add the item to the hotbar
			player.hotbar.inventory_data.add_item(item_data)
			# update the hotbat UI
			player.hotbar.update_inventory_dialog()
		
		# free the pick up item
		queue_free()
