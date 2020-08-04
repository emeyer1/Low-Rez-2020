extends Node


var MONSTERS = {
	"slime":{
		"Attacks":[1,1,1,3,5],
		"Health":10,
		"Sprite":"res://assets/monsters/testMonster.png",
		},

	"orc":{
		"Attacks":[3,3,7],
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
