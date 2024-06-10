extends Control


## the grabbed_slot (that is following the mouse).
@onready var grabbed_slot: Panel = %GrabbedSlot
## the UI of the player inventory .
@onready var player_inventory_dialog: PanelContainer = %PlayerInventoryDialog


# the slot data of the grabbed slot (that is following the mouse).
var grabbed_slot_data : SlotData


func _ready() -> void:
	# connect the inventory interacted signal
	# from the inventory_data resource of the player inventory dialog.
	player_inventory_dialog.inventory_data.inventory_interacted.connect(_inventory_interacted)


func _process(delta: float) -> void:
	# make the grabbed_slot follow the mouse with lerp
	grabbed_slot.position = lerp(grabbed_slot.position, get_local_mouse_position() + Vector2.ONE * 5, 0.5)
	
	
	# open and close inventory_dialog.
	if Input.is_action_just_pressed("Inventory"):
		visible = !visible


# this function is called when the inventory being interacted.
func _inventory_interacted(inventory_data : InventoryData , button_index, slot_index):
	# match the grabbed_slot_data, and the button index (which mouse button has been clicked).
	match [grabbed_slot_data, button_index]:
		# if there is no grabbed_slot_data (the player is not holding a slot by the mouse)
		# and the mouse button is the left one.
		[null, MOUSE_BUTTON_LEFT]:
			# get the slot_data of the given index and store it in grabbed_slot_data.
			grabbed_slot_data = inventory_data.grab_slot_data(slot_index)
			# set the slot_data of the grabbed_slot to the grabbed_slot_data.
			grabbed_slot.set_slot_data(grabbed_slot_data) 
			# update the inventory (to make the effect visually).
			player_inventory_dialog.update_inventory_dialog(inventory_data)
			# show the grabbed_slot
			grabbed_slot.show()
		# if the grabbed_slot_data has a "SlotData" (the player is holding a slot by the mosue)
		# and the mouse index is the left mouse.
		[_, MOUSE_BUTTON_LEFT]:
			#check if we can not put the data we have to the a slot with the given index.
			if !inventory_data.put_slot_data(slot_index, grabbed_slot.slot_data):
				# if so update the inventory and return (dont continue).
				player_inventory_dialog.update_inventory_dialog(inventory_data)		
				return
			# if yes :
			
			# update the inventory.
			player_inventory_dialog.update_inventory_dialog(inventory_data)
			# make the grabbed_slot_data null (because the put this data in a slot in the inventory).
			grabbed_slot_data = null
			# set the slot_dat of grabbed_slot to grabbed_slot_data (null) .
			grabbed_slot.set_slot_data(grabbed_slot_data)
			# hide the grabbed_slot.
			grabbed_slot.hide()
