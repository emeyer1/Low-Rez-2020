extends Node

#Random in script for choosing a power level.
var random = RandomNumberGenerator.new()

var MONSTERS = {
	"slime":{
		"AttackLoop":{
			0:{"Move_Type":"Slime","Value": null,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 3,"Next_Move":2},
			2:{"Move_Type":"Slime","Value": null,"Next_Move":3},
			3:{"Move_Type":"Damage","Value": 4,"Next_Move":0},
			},
		"Health":11,
		"Sprite":"res://assets/monsters/testMonster.png",
		"Currency": 1
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
		"Sprite":"res://assets/monsters/orc.png",
		"Currency": 1
	},
	"shade":{	
		"AttackLoop":{
			0:{"Move_Type":"Rest","Value": null,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 7,"Next_Move":2},
			2:{"Move_Type":"Rest","Value": null,"Next_Move":3},
			3:{"Move_Type":"Damage","Value": 6,"Next_Move":0}
			},
		"Health":10,
		"Sprite":"res://assets/monsters/shade.png",
		"Currency": 1
	},
	"snake":{
		"AttackLoop":{
			0:{"Move_Type":"Damage","Value": 200,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 200,"Next_Move":2},
			2:{"Move_Type":"Damage","Value": 200,"Next_Move":3},
			3:{"Move_Type":"Damage","Value": 200,"Next_Move":0}
			},
		"Health":99,
		"Sprite":"res://assets/monsters/snake.png",
		"Currency": 1
	},
	"spirit":{
		"AttackLoop":{
			0:{"Move_Type":"Shade","Value": null,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 3,"Next_Move":2},
			2:{"Move_Type":"Shade","Value": null,"Next_Move":3},
			3:{"Move_Type":"Damage","Value": 3,"Next_Move":0}
			},
		"Health":15,
		"Sprite":"res://assets/monsters/spirit2.png",
		"Currency": 1
	},
	"spiritCouncil":{
		"AttackLoop":{
			0:{"Move_Type":"Shade","Value": 2,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 4,"Next_Move":2},
			2:{"Move_Type":"Shade","Value": 2,"Next_Move":3},
			3:{"Move_Type":"Damage","Value": 4,"Next_Move":0}
			},
		"Health":25,
		"Sprite":"res://assets/monsters/spiritbuds.png",
		"Currency": 1
	},
	"spiritMage":{
		"AttackLoop":{
			0:{"Move_Type":"Slime","Value": null,"Next_Move":0},
			},
		"Health":5,
		"Sprite":"res://assets/monsters/spiritmage.png",
		"Currency": 1
	},
	"spiritBoss":{
		"AttackLoop":{
			0:{"Move_Type":"Shade","Value": null,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 4,"Next_Move":2},
			2:{"Move_Type":"Damage","Value": 10,"Next_Move":3},
			3:{"Move_Type":"Damage","Value": 4,"Next_Move":0}
			},
		"Health":40,
		"Sprite":"res://assets/monsters/spiritBoss.png",
		"Currency": 10
	},
	
	"error":{
		"AttackLoop":{
			0:{"Move_Type":"?","Value": null,"Next_Move":0}
			},
		"Health":99,
		"Sprite":"res://assets/monsters/error_monsters.png",
		"Currency": 0
		}
}

var MONSTER_ATTACKS = {
	"Damage":{"Sprite":"res://assets/ui/attack_icon.png","Tooltip":"Deals damage to you"},
	"Block":{"Sprite":"res://assets/ui/block_attack_icon.png","Tooltip":"Adds armor on top of health"},
	"Slime":{"Sprite":"res://assets/ui/splat_attack_icon.png","Tooltip":"Makes some blocks immovable for 1 turn"},
	"Shade":{"Sprite":"res://assets/ui/rage_attack_icon.png","Tooltip":"Conceals some tiles next turn"},
	"Rest":{"Sprite":"res://assets/ui/rest_attack_icon.png","Tooltip":"It is bored of you"},
	
	"Error":{"Sprite":"res://assets/ui/error.png","Tooltip":"Tooltip not found"}
}

var LEVEL_LIST = {
	"spirits":{
		1:{
			0:["slime","spiritCouncil","spirit"],
			1:["slime","spirit","spirit","spirit"]
			},
		2:{
			0:["spirit","spirit","spirit","spiritCouncil"],
			1:["spiritCouncil","spirit","spiritCouncil","spirit"],
			},
		3:{ #Highest power level = Boss
			0:["spiritMage","spiritBoss"]
			},
		#TEST POWER LEVEL
		0:{0:["spiritMage","spiritMage","spiritMage"]}
	},
	"shades":{1:{0:[]}},
	"error":{1:{0:[]}}

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
		
func get_level_list(power,theme):
	if theme in LEVEL_LIST:
		var list = LEVEL_LIST[theme][power]
		print(len(list))
		random.randomize()
		return list[random.randi_range(0,len(list)-1)]
	else:
		return LEVEL_LIST["error"]
