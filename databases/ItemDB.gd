extends Node


var ITEMS = {
	"sold":{
		"ItemName": "sold",
		"Currency": 0,
		"Sprite":"res://assets/items/3x1test.png",
		"Tooltip":"idk"
	},
	"ring":{
		"ItemName": "ring",
		"Currency": 3,
		"Sprite":"res://assets/items/1x1test.png",
		"Tooltip":"idk"
	},
	"sword":{
		"ItemName": "sword",
		"Currency": 5,
		"Sprite":"res://assets/items/1x3test.png",
		"Tooltip":"+1 Attack"
	},
	"flute":{
		"ItemName": "flute",
		"Currency": 9,
		"Sprite":"res://assets/items/2x1test.png",
		"Tooltip":"Extra move"
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
