extends Panel

# the slot needs a slot data
@export var slot_data : SlotData


# the children nodes
@onready var item_texture: TextureRect = %ItemTexture
@onready var quantity_label: Label = %QuantityLabel




func set_slot_data(new_slot_data : SlotData):
	# if there is no slot_data, stop!
	if !new_slot_data: return
	#  the slot data will be equal to the new slot data
	slot_data = new_slot_data
	print(slot_data, slot_data.item_data.Name, item_texture)
	item_texture.texture = slot_data.item_data.texture
	if slot_data.item_data.stackable:
		
		quantity_label.text = "%s" % slot_data.quantity
	else:
		quantity_label.hide()


#region tween
func _on_mouse_entered() -> void:
	# create the tween
	var scale_up_tween = create_tween()
	# tween the scale
	scale_up_tween.tween_property(self, "scale", Vector2.ONE * 1.2, 0.1)

func _on_mouse_exited() -> void:
	# create the tween
	var scale_up_tween = create_tween()
	# tween the scale
	scale_up_tween.tween_property(self, "scale", Vector2.ONE, 0.1)
#endregion
