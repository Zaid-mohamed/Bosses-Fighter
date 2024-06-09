extends Control


@onready var grabbed_slot: Panel = %GrabbedSlot
@onready var player_inventory_dialog: PanelContainer = %PlayerInventoryDialog

var grabbed_slot_data : SlotData


func _ready() -> void:
	player_inventory_dialog.inventory_data.inventory_interacted.connect(_inventory_interacted)


func _process(delta: float) -> void:
	grabbed_slot.position = get_local_mouse_position() + Vector2.ONE * 5
	
	
	# open and close inventory_dialog
	if Input.is_action_just_pressed("Inventory"):
		visible = !visible
		
func _inventory_interacted(inventory_data, button_index, slot_index):
	match [grabbed_slot_data, button_index]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(slot_index)
			grabbed_slot.set_slot_data(grabbed_slot_data) 
			
			player_inventory_dialog.update_inventory_dialog(inventory_data)
			grabbed_slot.show()
		[_, MOUSE_BUTTON_LEFT]:
			if !inventory_data.put_slot_data(slot_index, grabbed_slot.slot_data):
				player_inventory_dialog.update_inventory_dialog(inventory_data)		
				return
			player_inventory_dialog.update_inventory_dialog(inventory_data)
			grabbed_slot_data = null
			grabbed_slot.set_slot_data(grabbed_slot_data)
			grabbed_slot.hide()
		[null, MOUSE_BUTTON_RIGHT]:
			
			grabbed_slot_data = inventory_data.grab_slot_data_sliced(slot_index)
			grabbed_slot.set_slot_data(grabbed_slot_data) 
			player_inventory_dialog.update_inventory_dialog(inventory_data)
			grabbed_slot.show()
