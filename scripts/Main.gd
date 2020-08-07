extends Node2D

signal turn_start

onready var MonsterBase = load("res://Monster.tscn")
var random = RandomNumberGenerator.new()
var monsterSpawnList = ["slime","slime"]
var CurrentMonster

export var first_monster = "slime"

#Innkeeper Data
var IKhealth = 20
var turn_count = 0
var previous_turn = 0
var damage = 0
var armor = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_innkeeper()
	#spawn_monster(first_monster)
	CurrentMonster = $MonsterSpawn.get_child(0)

func _process(delta):
	#Spawn monster when space is open
	random.randomize()
	if $MonsterSpawn.get_child_count()<1:
		if len(monsterSpawnList)>0:
			#TODO: Get which monsters spawn and then determine a random new one up. Could do a random order to balance?
			spawn_monster(monsterSpawnList[0])
			monsterSpawnList.pop_front()
		else:
			print("Level Complete")
	
	
	#Set the swap count remaining
	$UI/swap_icon/Label.text = str($ViewportContainer/Viewport/TileGrid.moves_remaining)



	#Once turn ends, monster goes. Right now it just uses a random attack amount from the MonsterDB.
	#Handle attacks as a dict that are then matched? Damage:3, Blocks: 5, Row:1, Heal:10 etc.
	if previous_turn != turn_count:
		monster_turn()




	
	
func initialize_innkeeper():
	$UI/health_icon/InnkeeperHealth.text = str(IKhealth)
	update_armor()

func spawn_monster(value):
	var Monster = MonsterBase.instance()
	Monster.id = value
	$MonsterSpawn.add_child(Monster)
	CurrentMonster = $MonsterSpawn.get_child(0)

func update_IK_health(amount):
	armor = armor - amount
	amount = max(amount - armor,0)
	IKhealth = IKhealth - amount
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
			"fireblock":
				damage += i["length"] * 1
			"earthblock":
				var new_armor = i["length"] * 1
				#INSERT: Animation for max armor
				armor = min(new_armor + armor,9)
				
	#User deals damage
	print(damage)
	$MonsterSpawn.get_child(0).update_health(damage)
	damage = 0
	update_armor()
	previous_turn = turn_count
	turn_count += 1
	emit_signal("turn_start")


func monster_turn():
	if CurrentMonster.current_move_type == "Damage":
		update_IK_health(CurrentMonster.current_move_value)
	
	CurrentMonster.next_attack()
	previous_turn = turn_count
