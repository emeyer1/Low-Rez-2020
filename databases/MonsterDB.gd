extends Node


var MONSTERS = {
	"slime":{
		"Moves":[],
		"Health":10,
		"Sprite":"res://assets/monsters/testMonster.png"
		},

	"orc":{
		"Moves":[],
		"Health":20,
		"Sprite":"res://assets/monsters/orc.png"
	},
	
	
	"error":{
		"Moves":null,
		"Health":null,
		"Sprite":null,
		}
}


func get_monster(id):
	if id in MONSTERS:
		return MONSTERS[id]
	else:
		return MONSTERS["error"]
