extends Control

signal item_selected(shop_item, item_id,rarity)


		

var id
var tile
export var type = "tile"
export var rarity = "common"

func _ready():
	which_item(type,rarity)
	

	#$Button/Cost.text = str(item["Currency"])
	#$Button.hint_tooltip = item["Tooltip"]
	#print(len("RR"))
	
	
	
func _on_Button_button_up():
	emit_signal("item_selected", self, id,rarity)
	
func which_item(type,rarity):
	if type == "tile":
		get_tile(rarity,id)

func get_tile(rarity,id):
	match rarity:
		"common":
			$shopTileFrame.modulate = "614b2b"
		"rare":
			$shopTileFrame.modulate = "5b6ee1"
	
	tile = ItemDb.get_shop_tile(rarity,id)
	$Cost.text = str(tile["Cost"])
	
	match tile["n"]:
		1:
			var x = Sprite.new()
			x.texture = load(ItemDb.get_tile_sprite(tile["Giving"][0]))
			x.position += Vector2(-1,-1)
			$Giving.add_child(x)

			var y = Sprite.new()
			y.texture = load(ItemDb.get_tile_sprite(tile["Getting"][0]))
			y.position += Vector2(-1,-1)
			$Getting.add_child(y)

		2:
			var pos_offset = Vector2(0,0)
			for i in tile["Giving"]:
				var x = Sprite.new()
				x.position += pos_offset
				x.texture = load(ItemDb.get_tile_sprite(i))
				$Giving.add_child(x)
				pos_offset += Vector2(-2,-2)
				
			pos_offset = Vector2(0,0)
			for i in tile["Getting"]:
				var y = Sprite.new()
				y.position += pos_offset
				y.texture = load(ItemDb.get_tile_sprite(i))
				$Getting.add_child(y)
				pos_offset += Vector2(-2,-2)

