extends Resource

## This Resouce Stores The InventoryData Of The Inventory (It Is The Invenotory Itself)
class_name InventoryData

## the array that contains all the slot datas of the inventory.
@export var slot_datas : Array[SlotData]


## this signal is emmited when one of the slots of the invenotry been clicked.
signal inventory_interacted (inventory_data: InventoryData, button_index: int, slot_index: int, dialog)

## the function that called when a slot being clicked.
func _on_slot_clicked(index: int, button_index: int, dialog):
	inventory_interacted.emit(self, button_index, index, dialog)

## returns slot_data from slot_datas array by a given index.
func grab_slot_data(slot_index : int):
	# if there is no slot_data in this index, return null and stop.
	if slot_datas[slot_index] == null: return null
	
	# the slot_data is found and will store it in a variable.
	var slot_data = slot_datas[slot_index]
	
	# remove the slot from the inventory.
	slot_datas[slot_index] = null
	
	# we store this slot in a variable.
	var returned_slot_data = SlotData.new()
	returned_slot_data = slot_data
	
	# and return it.
	return returned_slot_data


## we dont need this function so I commented it
#func grab_slot_data_sliced(slot_index : int):
	#if  !slot_datas[slot_index] || !slot_datas[slot_index].item_data.stackable: return null
	#var new_slot_data = SlotData.new()
	#var grabbed_slot_data = SlotData.new()
	#
	#new_slot_data.item_data = slot_datas[slot_index].item_data
	#grabbed_slot_data.item_data = slot_datas[slot_index].item_data
	#if new_slot_data.quantity % 2 == 0:
		#
		#new_slot_data.quantity = slot_datas[slot_index].quantity / 2
	#else:
		#new_slot_data.quantity = (slot_datas[slot_index].quantity / 2)
		#grabbed_slot_data.quantity -= 1
	#
	#grabbed_slot_data = new_slot_data
	#
	#grabbed_slot_data.quantity -= 1 
	#slot_datas[slot_index] = new_slot_data
	#
	#
	#if grabbed_slot_data:
		#return grabbed_slot_data
	#else:
		#return null


## Put a slot_data in slot_datas in a certain given index in slot_datas (returbs true if succeful, false if not)
func put_slot_data(slot_index : int , new_slot_data : SlotData):
	# if there is a slot in this index.
	if slot_datas[slot_index]:
		# and have the item of the slot_data that should be put.
		if slot_datas[slot_index].item_data == new_slot_data.item_data:
			# and both of them is stackable.
			if slot_datas[slot_index].item_data.stackable:
				#increase the quantity of the slot
				slot_datas[slot_index].quantity += new_slot_data.quantity
				# return true
				return true
			else:
				# if not both of items inside them are stackable return false
				return false
			
		else:
			# if they have not the same item
			return false
		
	else:
		# there is no slot_data there.
		
		# we store the slot we want to add in a variable
		var added_slot_data = new_slot_data
		
		# insert this slot in the given index 
		slot_datas[slot_index] = added_slot_data
		
		# return true
		return true



# add an item to the inventory
func add_item(item_data : ItemData):
	
	## this section is not completed and will completed later
	
	## this section should add items on top of each other like 20 apples and 3 one 
	#for slot in slot_datas:
		#if slot.item_data == item_data:
			#slot.quantity += 1
			#break
			#return
			
	
	
	# a varibale that stores the index of the slot in iterations in for loop
	var index = -1
	# move in each slot data in slot datas in inventory
	for slot in slot_datas:
		# increase the index (because we moved an iteration)
		index += 1
		# if found empty slot
		if !slot:
			# create a new slot to add it there
			var new_slot_data = SlotData.new()
			# assign the item data of the new slot to the given item data
			new_slot_data.item_data = item_data
			# make the quantity one
			new_slot_data.quantity = 1
			# add the new slot in the correct index
			slot_datas[index] = new_slot_data
			# and stop
			break

# returns is the inventory full or not
func is_full() -> bool:
	# the variable that stores the state of full or not
	var is_inventory_full = true
	
	
	# move across slots
	for slot in slot_datas:
		# if one of them is empty
		if !slot:
			# so the inventory is not full
			is_inventory_full = false
			# and stop here
			break
	
	# return the result
	return is_inventory_full
	
	
	# note : if no slot is empty the variable will
	# continue as true so the function will return true
