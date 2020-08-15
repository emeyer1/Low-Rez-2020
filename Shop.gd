extends Control

var random = RandomNumberGenerator.new()

signal update_currency(new_currency)
signal shop_closed()
onready var ShopTileBase = load("res://ShopTile.tscn")
onready var ShopItemBase = load("res://ItemBase.tscn")
var currency = 9 #Need to get currency in base
var page = 1
var deck_counts = [0,0,0,0]

func _ready():
	deck_counts = update_deck_count()
	$UI/Currency.visible = false
	
	#ANIMATION Shop Spawn
	$UI/AnimatedSprite.play("StartShow")
	yield($UI/AnimatedSprite,"animation_finished")
	
	
	var j = 0
	for i in $TileItems.get_children():
		
		random.randomize()
		var tileItem = ShopTileBase.instance()
		#Add randomizer for common/rare?
		tileItem.rarity = "common"
			
		tileItem.id = random.randi_range(0,len(ItemDb.SHOP_TILES[tileItem.rarity])-1)
		tileItem.connect("item_selected",self,"_on_item_selected")
		i.add_child(tileItem)
		$UI/AnimatedSprite.play(str("ShowItem",j+1))
		yield($UI/AnimatedSprite,"animation_finished")
		j += 1

	j = 0
	for k in $Items.get_children():

		random.randomize()
		var Item = ShopItemBase.instance()
		#Update ID fetcher
		Item.id = ItemDb.ITEMS.keys()[random.randi_range(0,len(ItemDb.ITEMS)-1)]
		
		
		Item.connect("item_selected",self,"_on_not_tile_item_selected")
		k.add_child(Item)
		k.visible = false
		j += 1
	
	
	$UI/Currency.text = str(currency)
	$UI/Currency.visible = true
	
	$UI/AnimatedSprite.play("EndShow")
	yield($UI/AnimatedSprite,"animation_finished")
	

func _on_item_selected(tile_item, item_id,rarity):
	var tile = ItemDb.get_shop_tile(rarity,item_id)
	if currency >= tile["Cost"]:
		if compare_arrays(deck_counts, tile_item.giving_vec):
			tile_item.get_node("Button").disabled = true
			tile_item.disconnect("item_selected", self, "_on_item_selected")
			for i in tile["Giving"]:
				Deck.remove_tile(i)
			for j in tile["Getting"]:
				Deck.add_tile(j)
			#shop_item.disconnect("item_selected", self, "_on_item_selected")
			currency -= tile["Cost"]
			$UI/Currency.text = str(currency)
			emit_signal("update_currency", currency)
			deck_counts = update_deck_count()

func _on_not_tile_item_selected(item,id):
	var shop_item = ItemDb.get_item(id)
	if currency >= shop_item["Cost"]:
		item.get_node("TextureButton").disabled = true
		item.disconnect("item_selected", self, "_on_not_tile_item_selected")
		Deck.add_item(shop_item["Effect"])

		currency -= shop_item["Cost"]
		$UI/Currency.text = str(currency)
		emit_signal("update_currency", currency)
		


func _on_Button_button_up():
	emit_signal("shop_closed")
	self.queue_free()


func _on_ToPage2_button_down():
	if page == 1:
		$AudioStreamPlayer.play()
		$UI/AnimatedSprite.play("Page2")
		for i in $TileItems.get_children():
			i.visible = false
		for item in $Items.get_children():
			item.visible = true

		page = 2
	elif page == 2:
		$AudioStreamPlayer.play()
		$UI/AnimatedSprite.play("Page1")
		for i in $TileItems.get_children():
			i.visible = true
		for item in $Items.get_children():
			item.visible = false
		page = 1


func update_deck_count():
	var iter = 0
	var deck_array = [0,0,0,0]
	for i in Deck.deck:
		deck_array[iter] = Deck.get_tile(Deck.inplay,i["tileType"]).count + Deck.get_tile(Deck.deck,i["tileType"]).count
		iter += 1
	return deck_array

func compare_arrays(array1,array2):
	for i in len(array1):
		if array1[i] < array2[i]:
			return false
	return true
