extends Control

signal update_currency(new_currency)
signal shop_closed()
onready var ShopItemBase = load("res://ShopItem.tscn")
var currency = 9

func _ready():
#	for shopItemPos in $ShopItems.get_children():
#		var ShopItem = ShopItemBase.instance()
#		ShopItem.id = "ring"
#		shopItemPos.add_child(ShopItem)
	var ShopItem1 = ShopItemBase.instance()
	ShopItem1.id = "fire"
	ShopItem1.connect("item_selected", self, "_on_item_selected")
	$ShopItems/ShopItem1Pos.add_child(ShopItem1)
	var ShopItem2 = ShopItemBase.instance()
	ShopItem2.connect("item_selected", self, "_on_item_selected")
	ShopItem2.id = "earth"
	$ShopItems/ShopItem2Pos.add_child(ShopItem2)
	var ShopItem3 = ShopItemBase.instance()
	ShopItem3.connect("item_selected", self, "_on_item_selected")
	ShopItem3.id = "flute"
	$ShopItems/ShopItem3Pos.add_child(ShopItem3)
	
	$UI/Currency.text = str(currency)

func _on_item_selected(shop_item, item_id):
	var item = ItemDb.get_item(item_id)
	if currency >= item["Currency"]:
		match item["Type"]:
			"item":
				shop_item.disconnect("item_selected", self, "_on_item_selected")
				shop_item.get_node("Button/ItemName").text = "sold"
				Deck.add_item(item_id)
			"tile":
				Deck.add_tile(item_id)
		currency -= item["Currency"]
		$UI/Currency.text = str(currency)
		emit_signal("update_currency", currency)

func _on_Button_button_up():
	emit_signal("shop_closed")
	self.queue_free()
