extends Node2D

signal turn_start

onready var MonsterBase = load("res://Monster.tscn")
onready var ShopScreen = load("res://Shop.tscn")
var random = RandomNumberGenerator.new()
var monsterSpawnList = ["spiritCouncil","spirit","spiritCouncil","spiritMage","spiritBoss"]
var CurrentMonster

#Innkeeper Data
var IKhealth = 20
var turn_count = 0
var previous_turn = 0
var damage = 0
var armor = 0

#States:
var state = "NIGHT"

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_innkeeper()
	CurrentMonster = $MonsterSpawn.get_child(0)

func _process(delta):

	if state == "DAY":
		#Spawn Merchant
		#Spawn Shop
		#Shop Scene
		pass
	
	
	
	
	if state == "NIGHT":
		random.randomize()
		#Spawn monster when space is open
		if $MonsterSpawn.get_child_count()<1:
			if len(monsterSpawnList)>0:
				#TODO: Get which monsters spawn and then determine a random new one up. Could do a random order to balance?
				spawn_monster(monsterSpawnList[0])
				monsterSpawnList.pop_front()
			else:
				state = "DAY"
	
	
	#Set the swap count remaining
	$UI/swap_icon/Label.text = str($ViewportContainer/Viewport/TileGrid.moves_remaining)



	#Once turn ends, monster goes. Right now it just uses a random attack amount from the MonsterDB.
	#Handle attacks as a dict that are then matched? Damage:3, Blocks: 5, Row:1, Heal:10 etc.





	
	
func initialize_innkeeper():
	$UI/health_icon/InnkeeperHealth.text = str(IKhealth)
	update_armor()

func spawn_monster(value):
	var Monster = MonsterBase.instance()
	Monster.id = value
	$MonsterSpawn.add_child(Monster)
	CurrentMonster = $MonsterSpawn.get_child(0)

func update_IK_health(amount):
	var leftover_dmg = max(amount - armor,0)
	armor = max(armor-amount,0)
	update_armor()
	IKhealth = IKhealth - leftover_dmg
	$UI/health_icon/InnkeeperHealth.text = str(IKhealth)
	maybe_IK_dead()

func update_armor():
	if armor <= 0:
		$UI/armor_icon.visible = false
	else:
		$UI/armor_icon.visible = true
		$UI/armor_icon/Label.text = str(armor)
	
func maybe_IK_dead():
	if IKhealth <= 0:
		#Gameover screen goes here
		print("Inkeeper dead")


func _on_TileGrid_turn_ended(activations):
	
	#Handle tile type and activation:
	for i in activations:
		match i["tileType"]:
			"fire":
				damage += i["length"] * 2
			"earth":
				var new_armor = i["length"] * 1
				#INSERT: Animation for max armor
				armor = min(new_armor + armor,9)
				
	#User deals damage
	$MonsterSpawn.get_child(0).update_health(damage)
	damage = 0
	update_armor()
	previous_turn = turn_count
	turn_count += 1
	emit_signal("turn_start")
	monster_turn()


func monster_turn():
	if $MonsterSpawn.get_child_count() > 0:
		if CurrentMonster.current_move_type == "Damage":
			update_IK_health(CurrentMonster.current_move_value)
			
		CurrentMonster.next_attack()
		previous_turn = turn_count
