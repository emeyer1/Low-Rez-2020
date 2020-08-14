extends Node



var SHOP_TILES = {
	"common":{
		0:{"n":2,"Giving":["fire","fire"],"Getting":["empty","empty"],"Cost":5},
		1:{"n":1,"Giving":["fire"],"Getting":["empty"],"Cost":4},
		2:{"n":2,"Giving":["fire","fire"],"Getting":["earth","autoAttack"],"Cost":2},
		3:{"n":1,"Giving":["fire"],"Getting":["earth"],"Cost":1}
	},
	"rare":{
		0:{"n":1,"Giving":["fire"],"Getting":["earth"],"Cost":1}
	},
	"error":{
		0:{"Giving":"B","Getting":"B","Cost":20}
	}
}

var ITEMS = {
	"ring":{
		"ItemName": "ring",
		"Currency": 3,
		"Sprite":"res://assets/items/1x1test.png",
		"Tooltip":"+1 Def",
		"Type": "item",
		"Area": 1
	},
	"sword":{
		"ItemName": "sword",
		"Currency": 5,
		"Sprite":"res://assets/items/1x3test.png",
		"Tooltip":"+1 Atk",
		"Type": "item",
		"Area": 3
	},
	"flute":{
		"ItemName": "flute",
		"Currency": 9,
		"Sprite":"res://assets/items/2x1test.png",
		"Tooltip":"+1 mov",
		"Type": "item",
		"Area": 2
	},
	"error":{
		"ItemName": "error",
		"Currency": 10,
		"Sprite":"res://assets/items/1x1test.png",
		"Tooltip":"error",
		"Type": "item",
		"Area": 1
	},	
	"fire":{
		"ItemName": "fire",
		"Currency": 2,
		"Sprite": "res://assets/tiles/fireblock.png",
		"Tooltip":"+1 fire",
		"Type": "tile"
	},
	"earth":{
		"ItemName": "earth",
		"Currency": 2,
		"Sprite": "res://assets/tiles/earthblock.png",
		"Tooltip":"+1 earth",
		"Type": "tile"
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
