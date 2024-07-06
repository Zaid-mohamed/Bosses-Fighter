extends Resource

## This Resouce Stores The InventoryData Of The Inventory (It Is The Invenotory Itself)
class_name InventoryData

## the array that contains all the slot datas of the inventory.
@export var slot_datas : Array[SlotData]


## this signal is emmited when one of the slots of the invenotry been clicked.
signal inventory_interacted (inventory_data: InventoryData, button_index: int, slot_index: int, dialog)

## emmited when the inventory updates
signal inventory_updated (inventory_data : InventoryData)


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
	var returned_slot_data = slot_data
	
	# and emit the inventory updated signal
	inventory_updated.emit(self)
	# and return it.
	return returned_slot_data
	



## Put a slot_data in slot_datas in a certain given index in slot_datas (returns true if succefull, false if not)
func put_slot_data(slot_index : int , new_slot_data : SlotData):
	# if there is a slot in this index.
	if slot_datas[slot_index]:
		# and have the item of the slot_data that should be put.
		if slot_datas[slot_index].item_data == new_slot_data.item_data:
			# if the amount of the slot the player want to put there is equal to the stack size of this item,
			# don't continue
			if slot_datas[slot_index].quantity == slot_datas[slot_index].item_data.stack_size: return
			# and both of them is stackable.
			if slot_datas[slot_index].item_data.stackable:
				# store the amount needed to fill up 
				var needed_amount = slot_datas[slot_index].item_data.stack_size - slot_datas[slot_index].quantity
				#increase the quantity of the slot
				if needed_amount > new_slot_data.quantity: 
					slot_datas[slot_index].quantity += new_slot_data.quantity
					slot_datas[slot_index].quantity = 0
					inventory_updated.emit(self)
					return false
				else:
					slot_datas[slot_index].quantity += needed_amount
					new_slot_data.quantity -= needed_amount
				if new_slot_data.quantity > 0:
					inventory_updated.emit(self)
					return false
				# and emit the inventory updated signal
				inventory_updated.emit(self)
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
		
		# and emit the inventory updated signal
		inventory_updated.emit(self)
		
		# return true
		return true
		



# add an item to the inventory
func add_item(item_data : ItemData, amount : int = 1):
	
	## this section should add items on top of each other like 20 apples and 3 one 
	for slot in slot_datas:
		if !slot: continue
		
		# if the slot item is the needed item
		if slot.item_data == item_data:
			# create a variable storing the needed amount to fill the slot
			var needed_amount = clamp(slot.item_data.stack_size - slot.quantity, 0, slot.item_data.stack_size)
			# add the needed amount to the quantity
			if amount >= needed_amount:
				slot.quantity += needed_amount
				# decrease the amount by the needed amount, (because they are added to the slot)
				amount -= needed_amount
			else:
				slot.quantity += amount
				amount = 0
			
			# emit the inventory_updated
			inventory_updated.emit(self)
			# this item is got, so it is got before
			item_data.got_before = true
			# if there are amount not added to slots yet
			print("amount just before if statement. %s" % amount)
			if amount > 0:
				# go to the next slot
				continue
			else:
				# if there is no amount to put left, stop and end the function
				break
				return true
			
	
	## if there is no item like this in the inventory this section will run (as I expect)
	
	# a varibale that stores the index of the slot in iterations in for loop
	var index = -1
	# move in each slot data in slot datas in inventory
	for slot in slot_datas:
		# there is no amount remaining if the prevuis method procceded, don'continue
		if amount <= 0: return
		# increase the index (because we moved an iteration)
		index += 1
		# if found empty slot
		if !slot:
			
			# create a new slot to add it there
			var new_slot_data = SlotData.new()
			# assign the item data of the new slot to the given item data
			new_slot_data.item_data = item_data
			# if the amount needed to put there is larger than or equal the stack size of the item needed
			if amount >= new_slot_data.item_data.stack_size:
				# add the stack size to the quantity (fill up the slot)
				new_slot_data.quantity = new_slot_data.item_data.stack_size
				# and remove that amount from the amount
				amount -= new_slot_data.item_data.stack_size
			else: # if the amount is less than the stack size
				# add all the amount to the slot
				new_slot_data.quantity = amount
				# the amount is zero (added all amount)
				amount = 0
			
			# add the new slot in the correct index
			slot_datas[index] = new_slot_data
			
			# and emit the inventory updated signal
			inventory_updated.emit(self)
			# the item is got, so it is got before
			item_data.got_before = true
			# and stop
			
			# if there is more amount remained not added to the inventory
			if amount > 0:
				# move to the next slot (i don't know why but it works like that :)#
				continue
			
			else:
				# if there is not, stop the for loop
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


# removes an item from the inventory by a certain amount
func remove_item(item_data : ItemData, amount : int = 1) -> void:
	# a variable that stores if the requested item data if found or not
	var found_requested_item_data = false
	# move in each slot in slots datas
	for slot in slot_datas:
		# if there is no slot in this place, go to the next iterate
		if !slot:
			continue
		# if the slot have the same item as the requested one
		if slot.item_data == item_data:
			# the function found the requested item
			found_requested_item_data = true
			# if the quanitity is more than requested amount of erasing
			if slot.quantity > amount:
				slot.quantity -= amount
			else:
				# else erase the hole slot
				#slot_datas.erase(slot)
				slot_datas[slot_datas.find(slot)] = null
			break
			return


# is the inventory have this item in one of the slots?
func has_item(item_data : ItemData) -> bool:
	# move in each slot in slot datas
	for slot in slot_datas:
		# if the slot have the same item as the requested one
		if !slot: continue
		# if one of these slot have the requested item
		if slot.item_data == item_data:
			return true
			# and stop
			break
	# if not return false 
	return false
