extends Node


var MONSTERS = {
	"slime":{
		"Moves":[],
		"Health":[5,10,15],
		"Sprite":"res://Sprites/Monsters/1001.png",
		"Stamina_Max":4,
		"Speed":20},

	
	"error":{
		"Name":null,
		"Moves":null,
		"Base Stats":null,
		"Sprite":null,
		"Health_Max":null,
		"Stamina_Max":null,
		"Speed":null
		}
}


func get_monster(id):
	if id in MONSTERS:
		return MONSTERS[id]
	else:
		return MONSTERS["error"]
