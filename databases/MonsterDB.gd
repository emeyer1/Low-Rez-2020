extends Node


var MONSTERS = {
	"slime":{
		"AttackLoop":{
			0:{"Move_Type":"Block","Value": null,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 1,"Next_Move":2},
			2:{"Move_Type":"Splat","Value": null,"Next_Move":3},
			3:{"Move_Type":"Rage","Value": null,"Next_Move":4},
			4:{"Move_Type":"Damage","Value": 2,"Next_Move":5},
			5:{"Move_Type":"Splat","Value": null,"Next_Move":0}
			},
		"Health":10,
		"Sprite":"res://assets/monsters/testMonster.png",
		},

	"orc":{
		"AttackLoop":{
			0:{"Move_Type":"Block","Value": 5,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 2,"Next_Move":2},
			2:{"Move_Type":"Block","Value": 3,"Next_Move":3},
			3:{"Move_Type":"Rage","Value": null,"Next_Move":4},
			4:{"Move_Type":"Damage","Value": 2,	"Next_Move":0}
			},
		"Health":20,
		"Sprite":"res://assets/monsters/orc.png"
	},
	"shade":{
		"AttackLoop":{
			0:{"Move_Type":"Rest","Value": null,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 7,"Next_Move":2},
			2:{"Move_Type":"Rest","Value": null,"Next_Move":3},
			3:{"Move_Type":"Damage","Value": 6,"Next_Move":0}
			},
		"Health":10,
		"Sprite":"res://assets/monsters/shade.png"
	},
	"snake":{
		"AttackLoop":{
			0:{"Move_Type":"Block","Value": null,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 20,"Next_Move":2},
			2:{"Move_Type":"Block","Value": null,"Next_Move":3},
			3:{"Move_Type":"Damage","Value": 20,"Next_Move":0}
			},
		"Health":99,
		"Sprite":"res://assets/monsters/snake-sheet.png"
	},
	"spirit":{
		"AttackLoop":{
			0:{"Move_Type":"Damage","Value": 1,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 3,"Next_Move":2},
			2:{"Move_Type":"Damage","Value": 1,"Next_Move":3},
			3:{"Move_Type":"Damage","Value": 3,"Next_Move":0}
			},
		"Health":15,
		"Sprite":"res://assets/monsters/spirit2.png"
	},
	"spiritCouncil":{
		"AttackLoop":{
			0:{"Move_Type":"Damage","Value": 2,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 4,"Next_Move":2},
			2:{"Move_Type":"Damage","Value": 2,"Next_Move":3},
			3:{"Move_Type":"Damage","Value": 4,"Next_Move":0}
			},
		"Health":25,
		"Sprite":"res://assets/monsters/spiritbuds.png"
	},
	"spiritMage":{
		"AttackLoop":{
			0:{"Move_Type":"Rest","Value": null,"Next_Move":0},
			},
		"Health":5,
		"Sprite":"res://assets/monsters/spiritmage.png"
	},
	"spiritBoss":{
		"AttackLoop":{
			0:{"Move_Type":"Damage","Value": 10,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 4,"Next_Move":2},
			2:{"Move_Type":"Damage","Value": 10,"Next_Move":3},
			3:{"Move_Type":"Damage","Value": 4,"Next_Move":0}
			},
		"Health":40,
		"Sprite":"res://assets/monsters/spiritBoss.png"
	},
	
	"error":{
		"AttackLoop":{
			0:{"Move_Type":"?","Value": null,"Next_Move":0}
			},
		"Health":99,
		"Sprite":"res://assets/monsters/error_monsters.png",
		}
}

var MONSTER_ATTACKS = {
	"Damage":{"Sprite":"res://assets/ui/attack_icon.png","Tooltip":"Deals damage to you"},
	"Block":{"Sprite":"res://assets/ui/block_attack_icon.png","Tooltip":"Adds armor on top of health"},
	"Splat":{"Sprite":"res://assets/ui/splat_attack_icon.png","Tooltip":"Makes some blocks immovable for 1 turn"},
	"Rage":{"Sprite":"res://assets/ui/rage_attack_icon.png","Tooltip":"Increaes next atk by 2x"},
	"Rest":{"Sprite":"res://assets/ui/rest_attack_icon.png","Tooltip":"It is bored of you"},
	
	"Error":{"Sprite":"res://assets/ui/error.png","Tooltip":"Tooltip not found"}
}



func get_monster(id):
	if id in MONSTERS:
		return MONSTERS[id]
	else:
		return MONSTERS["error"]

func get_attack(id):
	if id in MONSTER_ATTACKS:
		return MONSTER_ATTACKS[id]
	else:
		return MONSTER_ATTACKS["Error"]
