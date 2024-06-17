extends Area2D


# the item in the ground
@export var item_data : ItemData


@onready var item_sprite: Sprite2D = %ItemSprite



func _ready() -> void:
	item_sprite.texture = item_data.texture


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.inventory_dialog.inventory_data.add_item(item_data)
		body.inventory_dialog.update_inventory_dialog(body.inventory_dialog.inventory_data)
		queue_free()
