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
			0:{"Move_Type":"Damage","Value": 5,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 2,"Next_Move":2},
			2:{"Move_Type":"Damage","Value": 3,"Next_Move":3},
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
			0:{"Move_Type":"Mirror","Value": null,"Next_Move":0}
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
			0:{"Move_Type":"Shade","Value": null,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 4,"Next_Move":2},
			2:{"Move_Type":"Shade","Value": null,"Next_Move":3},
			3:{"Move_Type":"Damage","Value": 4,"Next_Move":0}
			},
		"Health":25,
		"Sprite":"res://assets/monsters/spiritbuds.png",
		"Currency": 1
	},
	"spiritMage":{
		"AttackLoop":{
			0:{"Move_Type":"Shade","Value": null,"Next_Move":1},
			1:{"Move_Type":"Damage","Value":3,"Next_Move":2},
			2:{"Move_Type":"Shade","Value":null,"Next_Move":3},
			3:{"Move_Type":"Heal","Value":5,"Next_Move":0},
			},
		"Health":20,
		"Sprite":"res://assets/monsters/spiritmage.png",
		"Currency": 1
	},
	"spiritBoss":{
		"AttackLoop":{
			0:{"Move_Type":"Shade","Value": null,"Next_Move":1},
			1:{"Move_Type":"Mirror","Value": null,"Next_Move":2},
			2:{"Move_Type":"Damage","Value": 10,"Next_Move":3},
			3:{"Move_Type":"Damage","Value": 4,"Next_Move":0}
			},
		"Health":40,
		"Sprite":"res://assets/monsters/spiritBoss.png",
		"Currency": 10
	},
	"frostGiant":{
		"AttackLoop":{
			0:{"Move_Type":"Rage","Value": null,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 5,"Next_Move":2},
			2:{"Move_Type":"Damage","Value": 4,"Next_Move":3},
			3:{"Move_Type":"Frost","Value": null,"Next_Move":0}
			},
		"Health":20,
		"Sprite":"res://assets/monsters/frostgiant.png",
		"Currency": 2
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
	#"Block":{"Sprite":"res://assets/ui/block_attack_icon.png","Tooltip":"Adds armor on top of health"},
	"Slime":{"Sprite":"res://assets/ui/splat_attack_icon.png","Tooltip":"Makes some tiles immovable for 1 turn"},
	"Shade":{"Sprite":"res://assets/ui/shade_attack_icon.png","Tooltip":"Conceals some tiles till you move"},
	"Rest":{"Sprite":"res://assets/ui/rest_attack_icon.png","Tooltip":"It is bored of you"},
	"Rage":{"Sprite":"res://assets/ui/rage_attack_icon.png","Tooltip":"Next attack is 2x"},
	"Heal":{"Sprite":"res://assets/ui/heal_attack_icon.png","Tooltip":"Gains health"},
	"Frost":{"Sprite":"res://assets/ui/frost_attack_icon.png","Tooltip":"-1 moves next turn"},
	"Mirror":{"Sprite":"res://assets/ui/mirror_attack_icon.png","Tooltip":"Reflects damage taken this turn"},
	"Error":{"Sprite":"res://assets/ui/error.png","Tooltip":"Tooltip not found"}
}

var LEVEL_LIST = {
	"spirits":{
		1:{
			0:["spirit","spiritCouncil","spiritMage"]
			#1:["frostGiant","spirit","spirit","spirit"]
			},
		2:{
			0:["frostGiant","frostGiant","spiritCouncil"]
			#1:["frostGiant","spiritCouncil","spirit","spiritCouncil","spirit"],
			},
		3:{ #Highest power level = Boss
			0:["spiritMage","spiritBoss"]
			},
		#TEST POWER LEVEL
		0:{0:["snake"]}
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
