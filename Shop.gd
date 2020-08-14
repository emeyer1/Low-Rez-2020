extends Control

var random = RandomNumberGenerator.new()

signal update_currency(new_currency)
signal shop_closed()
onready var ShopItemBase = load("res://ShopItem.tscn")
var currency = 9 #Need to get currency in base
var page = 1

func _ready():
	
	$UI/Currency.visible = false
	
	#ANIMATION Shop Spawn
	$UI/AnimatedSprite.play("StartShow")
	yield($UI/AnimatedSprite,"animation_finished")
	
	var j = 0
	for i in $TileItems.get_children():
		random.randomize()
		var item = ShopItemBase.instance()
		item.id = random.randi_range(0,3)
		item.rarity = "common"

		item.connect("item_selected",self,"_on_item_selected")
		i.add_child(item)
		$UI/AnimatedSprite.play(str("ShowItem",j+1))
		yield($UI/AnimatedSprite,"animation_finished")
		j += 1

	
	$UI/Currency.text = str(currency)
	$UI/Currency.visible = true
	
	$UI/AnimatedSprite.play("EndShow")
	yield($UI/AnimatedSprite,"animation_finished")
	
#	for shopItemPos in $ShopItems.get_children():
#		var ShopItem = ShopItemBase.instance()
#		ShopItem.id = "ring"
#		shopItemPos.add_child(ShopItem)
#	var ShopItem1 = ShopItemBase.instance()
#	ShopItem1.id = "fire"
#	ShopItem1.connect("item_selected", self, "_on_item_selected")
#	$ShopItems/ShopItem1Pos.add_child(ShopItem1)
#	var ShopItem2 = ShopItemBase.instance()
#	ShopItem2.connect("item_selected", self, "_on_item_selected")
#	ShopItem2.id = "earth"
#	$ShopItems/ShopItem2Pos.add_child(ShopItem2)
#	var ShopItem3 = ShopItemBase.instance()
#	ShopItem3.connect("item_selected", self, "_on_item_selected")
#	ShopItem3.id = "flute"
#	$ShopItems/ShopItem3Pos.add_child(ShopItem3)
	


func _on_item_selected(shop_item, item_id,rarity):
	var item = ItemDb.get_shop_tile(rarity,item_id)
	if currency >= item["Cost"]:
		#match item["Type"]:
			#"item":
		#shop_item.get_node("Button").disabled = true
		#shop_item.disconnect("item_selected", self, "_on_item_selected")
				#Deck.add_item(item_id)
		#shop_item.disconnect("item_selected", self, "_on_item_selected")
		currency -= item["Cost"]
		$UI/Currency.text = str(currency)
		emit_signal("update_currency", currency)

func _on_Button_button_up():
	emit_signal("shop_closed")
	self.queue_free()


func _on_ToPage2_button_down():
	if page == 1:
		$UI/AnimatedSprite.play("Page2")
		for i in $TileItems.get_children():
			i.visible = false

		page = 2
	elif page == 2:
		$UI/AnimatedSprite.play("Page1")
		for i in $TileItems.get_children():
			i.visible = true
		page = 1
