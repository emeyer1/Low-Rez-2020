extends Node2D

signal turn_start

onready var MonsterBase = load("res://Monster.tscn")
onready var ShopScreen = load("res://Shop.tscn")
var random = RandomNumberGenerator.new()
#var monsterSpawnList = ["spiritCouncil","spirit","spiritCouncil","spiritMage","spiritBoss"]
var monsterSpawnList = ["spiritMage"]
var CurrentMonster

#Innkeeper Data
var IKhealth = 20
var IKhealth_max = IKhealth
var turn_count = 0
var previous_turn = 0
var damage = 0
var armor = 0
var IKcurrency = 2

#States:
var state = "NIGHT"

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_innkeeper()
	set_Night()


func _process(delta):
	#Set the swap count remaining
	$UI/swap_icon/Label.text = str($ViewportContainer/Viewport/TileGrid.moves_remaining)


	#Once turn ends, monster goes. Right now it just uses a random attack amount from the MonsterDB.
	#Handle attacks as a dict that are then matched? Damage:3, Blocks: 5, Row:1, Heal:10 etc.


func set_Day():
	IKhealth = IKhealth_max
	armor = 0
	$Background/MerchantBase.visible = true #TODO: make it an animation entrance. 
	$Background/Outside.modulate = "#ffff00"
	#Spawn Shop
	#Shop Scene

func set_Night():
	$Background/MerchantBase.visible = false
	$Background/Outside.modulate = "#000000"
	random.randomize()
	#Spawn monster when space is open
	spawn_monster(monsterSpawnList[0])
	monsterSpawnList.pop_front()
	
	
func initialize_innkeeper():
	$UI/health_icon/InnkeeperHealth.text = str(IKhealth)
	$UI/Currency/Label.text = str(IKcurrency)
	update_armor()

func spawn_monster(value):
	var Monster = MonsterBase.instance()
	Monster.id = value
	Monster.connect("monster_dead",self,"monster_died")
	$MonsterSpawn.add_child(Monster)
	CurrentMonster = $MonsterSpawn.get_child(0)

func monster_died(currency):
	IKcurrency = min(currency+IKcurrency,99)
	$UI/Currency/Label.text = str(IKcurrency)
	if len(monsterSpawnList)>0:
		#TODO: Get which monsters spawn and then determine a random new one up. Could do a random order to balance?
		spawn_monster(monsterSpawnList[0])
		monsterSpawnList.pop_front()
	else:
		set_Day()

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
		get_tree().paused = true
		var gameOver = load("res://GameOverScreen.tscn").instance()
		add_child(gameOver)

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
	monster_turn()
	
	emit_signal("turn_start")
	


func monster_turn():
	if $MonsterSpawn.get_child_count() > 0:
		
		match CurrentMonster.current_move_type:
			"Damage":
				update_IK_health(CurrentMonster.current_move_value)
			
		CurrentMonster.next_attack()
		previous_turn = turn_count
