extends Resource

class_name InventoryData


@export var slot_datas : Array[SlotData]

signal inventory_interacted (inventory_data, button_index, slot_index)

# the function that called the a slot being clicked
func _on_slot_clicked(index, button_index):
	inventory_interacted.emit(self, button_index, index)


func grab_slot_data(slot_index : int):
	if slot_datas[slot_index] == null: return
	var slot_data = slot_datas[slot_index]
	slot_datas[slot_index] = null
	return slot_data

func grab_slot_data_sliced(slot_index : int):
	if slot_datas[slot_index] == null: return false
	
	var new_slot_data = SlotData.new()
	
	new_slot_data =  slot_datas[slot_index]
	
	new_slot_data.quantity /= 2
	
	slot_datas[slot_index].quantity /= 2
	
	return new_slot_data

func put_slot_data(slot_index : int , new_slot_data : SlotData):
	var added_slot_data = new_slot_data
	
	print("reached put_slot_data")
	if slot_datas[slot_index] != null : return
	
	slot_datas[slot_index] = added_slot_data
	return true

