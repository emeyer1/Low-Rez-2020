extends Node

#Random in script for choosing a power level.
var random = RandomNumberGenerator.new()

var MONSTERS = {
	"spirit":{
		"AttackLoop":{
			0:{"Move_Type":"Shade","Value": null,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 3,"Next_Move":2},
			2:{"Move_Type":"Shade","Value": null,"Next_Move":3},
			3:{"Move_Type":"Damage","Value": 3,"Next_Move":0}
			},
		"Health":15,
		"Idle":"spirit_Idle",
		"Attack":null,
		"Damaged":null,
		"Currency": 3
	},
	"spiritCouncil":{
		"AttackLoop":{
			0:{"Move_Type":"Shade","Value": null,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 4,"Next_Move":2},
			2:{"Move_Type":"Shade","Value": null,"Next_Move":3},
			3:{"Move_Type":"Damage","Value": 4,"Next_Move":0}
			},
		"Health":30,
		"Idle":"spiritCouncil_Idle",
		"Attack":null,
		"Damaged":null,
		"Currency": 3
	},
	"gremlin":{
		"AttackLoop":{
			0:{"Move_Type":"Shade","Value": null,"Next_Move":1},
			1:{"Move_Type":"Damage","Value":3,"Next_Move":2},
			2:{"Move_Type":"Shade","Value":null,"Next_Move":3},
			3:{"Move_Type":"Heal","Value":5,"Next_Move":0},
			},
		"Health":20,
		"Idle":"gremlin_Idle",
		"Attack":null,
		"Damaged":null,
		"Currency": 3
	},
	"spiritBoss":{
		"AttackLoop":{
			0:{"Move_Type":"Shade","Value": null,"Next_Move":1},
			1:{"Move_Type":"Mirror","Value": null,"Next_Move":2},
			2:{"Move_Type":"Damage","Value": 10,"Next_Move":3},
			3:{"Move_Type":"Rage","Value": null,"Next_Move":4},
			4:{"Move_Type":"Damage","Value": 7,"Next_Move":0}
			},
		"Health":40,
		"Idle":"spiritBoss_Idle",
		"Attack":null,
		"Damaged":null,
		"Currency": 20
	},
	"slime":{
		"AttackLoop":{
			0:{"Move_Type":"Slime","Value": null,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 3,"Next_Move":2},
			2:{"Move_Type":"Slime","Value": null,"Next_Move":3},
			3:{"Move_Type":"Damage","Value": 4,"Next_Move":0}
			},
		"Health":30,
		"Sprite":"res://assets/monsters/testMonster.png",
		"Idle":"slime_Idle",
		"Attack":null,
		"Damaged":null,
		"Currency": 3
		},
	"slimeBuddies":{
		"AttackLoop":{
			0:{"Move_Type":"Slime","Value": null,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 3,"Next_Move":2},
			2:{"Move_Type":"Block","Value": 3,"Next_Move":3},
			3:{"Move_Type":"Slime","Value": null,"Next_Move":4},
			4:{"Move_Type":"Heal","Value":5,"Next_Move":5},
			5:{"Move_Type":"Damage","Value": 4,"Next_Move":0}
			},
		"Health":40,
		"Idle":"slimeBuddies_Idle",
		"Attack":null,
		"Damaged":null,
		"Currency": 4
	},
	"slimeBoss":{
		"AttackLoop":{
			0:{"Move_Type":"Slime","Value": null,"Next_Move":1},
			1:{"Move_Type":"Rage","Value": null,"Next_Move":2},
			2:{"Move_Type":"Damage","Value": 10,"Next_Move":3},
			3:{"Move_Type":"Slime","Value": null,"Next_Move":4},
			4:{"Move_Type":"Damage","Value": 10,"Next_Move":0}
			},
		"Health":80,
		"Idle":"slimeBoss_Idle",
		"Attack":null,
		"Damaged":null,
		"Currency": 20
	},
	"frostMage":{
		"AttackLoop":{
			0:{"Move_Type":"Rage","Value": null,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 5,"Next_Move":2},
			2:{"Move_Type":"Block","Value": 1,"Next_Move":3},
			3:{"Move_Type":"Frost","Value": null,"Next_Move":0}
			},
		"Health":30,
		"Sprite":"res://assets/monsters/frostgiant.png",
		"Idle":"frostMage_Idle",
		"Attack":null,
		"Damaged":null,
		"Currency": 3
	},
	"frostMageElite":{
		"AttackLoop":{
			0:{"Move_Type":"Frost","Value": null,"Next_Move":1},
			1:{"Move_Type":"Mirror","Value": null,"Next_Move":2},
			2:{"Move_Type":"Block","Value": 1,"Next_Move":3},
			3:{"Move_Type":"Mirror","Value": null,"Next_Move":4},
			4:{"Move_Type":"Damage","Value": 10,"Next_Move":0}
			},
		"Health":35,
		"Idle":"frostMageElite_Idle",
		"Attack":null,
		"Damaged":null,
		"Currency": 4
	},
	"frostBoss":{
		"AttackLoop":{
			0:{"Move_Type":"Block","Value": 2,"Next_Move":1},
			1:{"Move_Type":"Mirror","Value": null,"Next_Move":2},
			2:{"Move_Type":"Rage","Value": null,"Next_Move":3},
			3:{"Move_Type":"Damage","Value": 7,"Next_Move":0}
			},
		"Health":60,
		"Sprite":"res://assets/monsters/frostgiant.png",
		"Idle":"frostBoss_Idle",
		"Attack":null,
		"Damaged":null,
		"Currency": 20
	},
	"snake":{
		"AttackLoop":{
			0:{"Move_Type":"Block","Value": 2,"Next_Move":1},
			1:{"Move_Type":"Damage","Value": 10,"Next_Move":2},
			2:{"Move_Type":"Block","Value": 1,"Next_Move":0}
			},
		"Health":40,
		"Sprite":"res://assets/monsters/snake.png",
		"Idle":"snake_Idle",
		"Attack":null,
		"Damaged":null,
		"Currency": 0
	},
	"slumpoMasterOfAll":{
		"AttackLoop":{
			0:{"Move_Type":"Block","Value": 2,"Next_Move":1},
			1:{"Move_Type":"Mirror","Value": null,"Next_Move":2},
			2:{"Move_Type":"Rage","Value": null,"Next_Move":3},
			3:{"Move_Type":"Damage","Value": 15,"Next_Move":4},
			4:{"Move_Type":"Slime","Value": null,"Next_Move":5},
			5:{"Move_Type":"Damage","Value": 10,"Next_Move":6},
			6:{"Move_Type":"Shade","Value": null,"Next_Move":7},
			7:{"Move_Type":"Damage","Value": 10,"Next_Move":8},
			8:{"Move_Type":"Heal","Value": 20,"Next_Move":9},
			9:{"Move_Type":"Damage","Value": 10,"Next_Move":0},
			},
		"Health":99,
		"Idle":"slump_Idle",
		"Attack":null,
		"Damaged":null,
		"Currency": 0
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
	"Block":{"Sprite":"res://assets/ui/block_attack_icon.png","Tooltip":"Blocks an amount of incoming damage"},
	"Slime":{"Sprite":"res://assets/ui/splat_attack_icon.png","Tooltip":"Makes some tiles immovable for 1 turn"},
	"Shade":{"Sprite":"res://assets/ui/shade_attack_icon.png","Tooltip":"Will conceal some tiles till you move"},
	"Rest":{"Sprite":"res://assets/ui/rest_attack_icon.png","Tooltip":"It is bored of you"},
	"Rage":{"Sprite":"res://assets/ui/rage_attack_icon.png","Tooltip":"Next attack does 2x dmg"},
	"Heal":{"Sprite":"res://assets/ui/heal_attack_icon.png","Tooltip":"Gains health"},
	"Frost":{"Sprite":"res://assets/ui/frost_attack_icon.png","Tooltip":"-1 moves next turn"},
	"Mirror":{"Sprite":"res://assets/ui/mirror_attack_icon.png","Tooltip":"Reflects damage taken this turn"},
	"Error":{"Sprite":"res://assets/ui/error.png","Tooltip":"Tooltip not found"}
}

var LEVEL_LIST = {
		1:{
			0:["spirit","spirit","gremlin"], #9 currency
			1:["spiritCouncil","spirit","spirit"] #9 currency
			},
		2:{
			0:["spiritCouncil","gremlin","spiritCouncil","spirit"], #10 currency
			1:["spiritCouncil","spiritCouncil","gremlin","spirit"] #10 currency
			},
		3:{0:["spiritBoss"]}, #20 curency
		
		4:{0:["frostMage","frostMageElite","frostMage"] #10 currency
			#1:[]
			},
		5:{0:["frostMageElite","frostMageElite","frostMage"] #11 currency
			#1:[]
			},
		6:{0:["frostBoss"]}, #20 currency
		7:{0:["slime","slime","slimeBuddies"]}, #10 currency
		8:{0:["slimeBuddies","slime","slimeBuddies"]}, #11 curency
		9:{0:["slimeBoss"]}, #20 currency
		10:{0:["snake","snake"]},
		#TEST POWER LEVEL:
		0:{0:["spiritBoss","spirit"]}
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
		
func get_level_list(power):
	if power in LEVEL_LIST:
		var list = LEVEL_LIST[power]
		random.randomize()
		return list[random.randi_range(0,len(list)-1)]
	else:
		return LEVEL_LIST["error"]
