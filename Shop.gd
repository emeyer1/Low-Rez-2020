extends Control

var random = RandomNumberGenerator.new()

signal update_currency(new_currency)
signal shop_closed()
onready var ShopTileBase = load("res://ShopTile.tscn")
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
		tileItem.id = random.randi_range(0,3)
		tileItem.rarity = "common"
		tileItem.connect("item_selected",self,"_on_item_selected")
		i.add_child(tileItem)
		$UI/AnimatedSprite.play(str("ShowItem",j+1))
		yield($UI/AnimatedSprite,"animation_finished")
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
