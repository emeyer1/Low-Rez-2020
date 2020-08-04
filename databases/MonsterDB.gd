extends Node


var MONSTERS = {
	"slime":{
		"AttackLoop":{
			0:{
			"Move_Type":"Rest",
			"Value": null,
			"Next_Move":1
			},
			1:{
			"Move_Type":"Damage",
			"Value": 1,
			"Next_Move":2
			},
			2:{
			"Move_Type":"Splat",
			"Value": 3,
			"Next_Move":3
			},
			3:{
			"Move_Type":"Damage",
			"Value": 3,
			"Next_Move":4
			},
			4:{
			"Move_Type":"Damage",
			"Value": 2,
			"Next_Move":5
			},
			5:{
			"Move_Type":"Splat",
			"Value": 5,
			"Next_Move":1
			}},
		"Health":10,
		"Sprite":"res://assets/monsters/testMonster.png",
		},

	"orc":{
		"AttackLoop":{
			0:{
			"Move_Type":"Block",
			"Value": 5,
			"Next_Move":1
			},
			1:{
			"Move_Type":"Damage",
			"Value": 2,
			"Next_Move":2
			},
			2:{
			"Move_Type":"Block",
			"Value": 3,
			"Next_Move":3
			},
			3:{
			"Move_Type":"Rage",
			"Value": 4,
			"Next_Move":4
			},
			4:{
			"Move_Type":"Damage",
			"Value": 2,
			"Next_Move":1
			}},
		"Health":20,
		"Sprite":"res://assets/monsters/orc.png"
	},
	
	
	"error":{
		"Moves":null,
		"Health":null,
		"Sprite":null,
		}
}

var MONSTER_ATTACKS = {
	"Damage":"res://assets/ui/attack_icon.png",
	"Block":"res://assets/ui/block_attack_icon.png",
	"Splat":"res://assets/ui/splat_attack_icon.png",
	"Rage":"res://assets/ui/rage_attack_icon.png",
	"Rest":"res://assets/ui/rest_attack_icon.png"
}



func get_monster(id):
	if id in MONSTERS:
		return MONSTERS[id]
	else:
		return MONSTERS["error"]
