extends Node



var SHOP_TILES = {
	"common":{
		0:{"n":2,"Giving":["empty","fire"],"Getting":["earth","earth"],"Cost":5},
		1:{"n":1,"Giving":["empty"],"Getting":["earth"],"Cost":4},
		2:{"n":2,"Giving":["fire","fire"],"Getting":["earth","autoAttack"],"Cost":2},
		3:{"n":1,"Giving":["fire"],"Getting":["earth"],"Cost":1},
		4:{"n":1,"Giving":["empty"],"Getting":["fire"],"Cost":4},
		5:{"n":1,"Giving":["empty"],"Getting":["autoAttack"],"Cost":2},
		6:{"n":2,"Giving":["autoAttack","earth"],"Getting":["empty","fire"],"Cost":2},
		7:{"n":1,"Giving":["earth"],"Getting":["fire"],"Cost":1},
		8:{"n":2,"Giving":["empty","empty"],"Getting":["fire","fire"],"Cost":4},
		9:{"n":2,"Giving":["fire","fire"],"Getting":["autoAttack","autoAttack"],"Cost":0},
		10:{"n":2,"Giving":["empty","empty"],"Getting":["autoAttack","autoAttack"],"Cost":5},
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
		"Cost": 5,
		"Sprite":"res://assets/items/apple.png",
		"Tooltip":"+5 Health",
		"Effect":[{"Health":5}]
	},
	"flute":{
		"ItemName": "flute",
		"Cost": 10,
		"Sprite":"res://assets/items/flute.png",
		"Tooltip":"+1 Move, -5 Health",
		"Effect":[{"Move":1},{"Health":-5}]
	},
	"shield":{
		"ItemName": "shield",
		"Cost": 15,
		"Sprite":"res://assets/items/shield.png",
		"Tooltip":"+1 Armor always, -5 Health",
		"Effect":[{"Armor":1},{"Health":-5}]
	},
	"sword":{
		"ItemName": "sword",
		"Cost": 10,
		"Sprite":"res://assets/items/sword.png",
		"Tooltip":"Basic Attack lineups: +1 dmg",
		"Effect":[{"AAdmg":1}]
	},
	"temp1":{
		"ItemName": "sword",
		"Cost": 5,
		"Sprite":"res://assets/items/temp.png",
		"Tooltip":"+10 Health, -1 dmg Basic Attack lineups",
		"Effect":[{"Health":10},{"AAdmg":-1}]
	},
	"temp2":{
		"ItemName": "sword",
		"Cost": 11,
		"Sprite":"res://assets/items/temp.png",
		"Tooltip":"+10 Health",
		"Effect":[{"Health":10}]
	},
	"temp3":{
		"ItemName": "sword",
		"Cost": 15,
		"Sprite":"res://assets/items/temp.png",
		"Tooltip":"+1 Move",
		"Effect":[{"Move":1}]
	},
	"temp4":{
		"ItemName": "sword",
		"Cost": -10,
		"Sprite":"res://assets/items/temp.png",
		"Tooltip":"-5 Health, +10 Gold",
		"Effect":[{"Health":-5}]
	},
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
