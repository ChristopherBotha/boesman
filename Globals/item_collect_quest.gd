class_name ItemCollectQuest

var _inventoryChannel: InventoryChannel
var _amountToCollect: int
var _playerInventory: Inventory

func quest_active():
	var item_in_inventory = _playerInventory.owned_items.find("Sticks")
	try_complete(item_in_inventory)
	InventoryChannel.connect("item_added", item_added_event)

func quest_completed():
	_inventoryChannel.disconnect("item_added", item_added_event)

func item_added_event(item_addition: int, updated_inventory_item):
	if _playerInventory.owned_items.item_name == item_addition:
		return

	try_complete(updated_inventory_item)

func try_complete(item_in_inventory):
	if item_in_inventory != null and item_in_inventory.amount >= _amountToCollect:
		QuestChannel.emit_signal("quest_completed")
