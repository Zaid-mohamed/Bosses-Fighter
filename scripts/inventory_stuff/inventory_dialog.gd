extends PanelContainer

@onready var slots_container: GridContainer = %SlotsContainer


@export var inventory_data : InventoryData


const SLOT_SCENE := preload("res://scenes/inventory stuff/slot.tscn")


func _ready() -> void:
	
	update_inventory_dialog(inventory_data)

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
