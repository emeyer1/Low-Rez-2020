extends Node


var ITEMS = {
	"ring":{
		"ItemName": "ring",
		"Currency": 3,
		"Sprite":"res://assets/items/1x1test.png",
		"Tooltip":"+1 Def"
	},
	"sword":{
		"ItemName": "sword",
		"Currency": 5,
		"Sprite":"res://assets/items/1x3test.png",
		"Tooltip":"+1 Atk"
	},
	"flute":{
		"ItemName": "flute",
		"Currency": 9,
		"Sprite":"res://assets/items/2x1test.png",
		"Tooltip":"+1 mov"
	},
	"error":{
		"ItemName": "error",
		"Currency": 10,
		"Sprite":"res://assets/items/1x1test.png",
		"Tooltip":"error"
	}
}


func get_item(id):
	if id in ITEMS:
		return ITEMS[id]
	else:
		return ITEMS["error"]
