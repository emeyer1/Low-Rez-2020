extends Node


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


func get_item(id):
	if id in ITEMS:
		return ITEMS[id]
	else:
		return ITEMS["error"]
