extends Node



var SHOP_TILES = {
	"common":{
		0:{"n":2,"Giving":["empty","fire"],"Getting":["earth","earth"],"Cost":5},
		1:{"n":1,"Giving":["empty"],"Getting":["earth"],"Cost":4},
		2:{"n":2,"Giving":["fire","fire"],"Getting":["earth","autoAttack"],"Cost":2},
		3:{"n":1,"Giving":["fire"],"Getting":["earth"],"Cost":1},
		4:{"n":1,"Giving":["empty"],"Getting":["fire"],"Cost":4},
		5:{"n":1,"Giving":["empty"],"Getting":["autoAttack"],"Cost":2},
		6:{"n":1,"Giving":["autoAttack","earth"],"Getting":["empty","fire"],"Cost":2},
	},
	"rare":{
		0:{"n":1,"Giving":["fire"],"Getting":["earth"],"Cost":1}
	},
	"error":{
		0:{"Giving":"B","Getting":"B","Cost":20}
	}
}

var ITEMS = {
	"apple":{
		"ItemName": "apple",
		"Cost": 3,
		"Sprite":"res://assets/items/test_item.png",
		"Tooltip":"+1 Health",
	}
}

var TILE_SPRITES = {
	"fire":"res://assets/tiles/fireblock.png",
	"earth": "res://assets/tiles/earthblock.png",
	"autoAttack": "res://assets/tiles/autoattack.png",
	"empty": "res://assets/tiles/block2.png",
	"error": "res://assets/tiles/water.png"
}


func get_item(id):
	if id in ITEMS:
		return ITEMS[id]
	else:
		return ITEMS["error"]

func get_shop_tile(rarity,id):
	if rarity in SHOP_TILES:
		return SHOP_TILES[rarity][id]
	else:
		return SHOP_TILES["error"]

func get_tile_sprite(tile):
	if tile in TILE_SPRITES:
		return TILE_SPRITES[tile]
	else:
		return TILE_SPRITES["error"]
