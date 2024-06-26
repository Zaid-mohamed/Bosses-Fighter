extends PanelContainer



# onready vars

## a grid container that holds the slots
@onready var slots_container: GridContainer = %SlotsContainer
# the indicator that shows to the player which slot is currently selceted
@onready var current_item_indicator: Sprite2D = %CurrentItemIndicator


# variables
# the hotbar need an invenotry data

@export var inventory_data : InventoryData


# a constant holds the scene of slot scene
const SLOT_SCENE := preload("res://scenes/inventory stuff/slot.tscn")

# the slot_data of the selected slot
var current_slot_data : SlotData
# the index of the selected slot

# the index of the selected slot
var current_slot_index : int :
	set(value):
		current_slot_index = clampi(value, 0, 2)

# signals


## emitted when current_slot_data changed
signal current_slot_data_changed (new_current_slot_data)





func _ready() -> void:
	
	update_inventory_dialog(inventory_data)



func _process(delta: float) -> void:
	
	handle_changing_selected_slot()
	
func update_inventory_dialog(inventory_data : InventoryData):
	# remove the old slots
	for slot in slots_container.get_children():
		slot.queue_free()
	
	
	for slot_data in inventory_data.slot_datas:
		# create an instance of the slot scene
		var SlotInstance = SLOT_SCENE.instantiate()
		# add it as a child to the inventory
		slots_container.add_child(SlotInstance)
		# give it the corrosponding slot data 
		SlotInstance.set_slot_data(slot_data)
		# hide the quantity label if there is no slot data
		if !slot_data: SlotInstance.quantity_label.hide()
		# the slot clicked signal to the inventory data
		SlotInstance.slot_clicked.connect(inventory_data._on_slot_clicked)	

# get the slot_data from a slot using its index
func get_slot_data(indx : int):
	# get the slot_data from the slot that the have the given index
	var slot_data = slots_container.get_children()[indx].slot_data
	# if couldn't find one, push an error and return null
	if !slot_data: push_error("Couldn't Find Slot Data"); return null
	# if found return it
	return slot_data
	

# handle the changing of the selected slot 
func handle_changing_selected_slot():
	# if pressed this E
	if Input.is_action_just_pressed("hotbar_right"):
		# increase the current_slot_index
		current_slot_index += 1
		# update the current_slot_data according to the current_slot_index
		current_slot_data = get_slot_data(current_slot_index)
		# emit the current_slot_data_changed and pass the current_slot_data
		current_slot_data_changed.emit(current_slot_data)
		# move the current_item_indicator
		current_item_indicator.position.x += 44
		# clamp the indicator pos to prevent it from going too far
		clamp_indicator_pos()
		
	elif Input.is_action_just_pressed("hotbar_left"):
		# decrease the current_slot_index		
		current_slot_index -= 1
		# update the current_slot_data according to the current_slot_index		
		current_slot_data = get_slot_data(current_slot_index)
		# emit the current_slot_data_changed and pass the current_slot_data
		current_slot_data_changed.emit(current_slot_data)
		# move the current_item_indicator
		current_item_indicator.position.x -= 44
		# clamp the indicator pos to prevent it from going too far
		clamp_indicator_pos()
		


# clamp the indicator pos to prevent it from goind too far
func clamp_indicator_pos():
	current_item_indicator.position.x = clampf(current_item_indicator.position.x, 27, 115)
