extends Node2D

signal turn_start

onready var MonsterBase = load("res://Monster.tscn")
var random = RandomNumberGenerator.new()
var monsters = ["slime","orc"]
var CurrentMonster

#Innkeeper Data
var IKhealth = 20
var turn_count = 0
var previous_turn = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_innkeeper()
	spawn_monster("slime")
	CurrentMonster = $MonsterSpawn.get_child(0)

func _process(delta):
	#Spawn monster when space is open
	random.randomize()
	if $MonsterSpawn.get_child_count()<1:
		#TODO: Get which monsters spawn and then determine a random new one up. Could do a random order to balance?
		var r = random.randi_range(0,1)
		spawn_monster(monsters[r])
	
	
	#Set the swap count remaining
	$UI/swap_icon/Label.text = str($ViewportContainer/Viewport/TileGrid.moves_remaining)



	#Once turn ends, monster goes. Right now it just uses a random attack amount from the MonsterDB.
	#Handle attacks as a dict that are then matched? Damage:3, Blocks: 5, Row:1, Heal:10 etc.
	if previous_turn != turn_count:
		monster_turn()




	
	
func initialize_innkeeper():
	$UI/health_icon/InnkeeperHealth.text = str(IKhealth)

func spawn_monster(value):
	var Monster = MonsterBase.instance()
	Monster.id = value
	$MonsterSpawn.add_child(Monster)
	CurrentMonster = $MonsterSpawn.get_child(0)

func update_IK_health(amount):
	IKhealth = IKhealth - amount
	$UI/health_icon/InnkeeperHealth.text = str(IKhealth)
	maybe_IK_dead()
	
func maybe_IK_dead():
	if IKhealth <= 0:
		#Gameover screen goes here
		print("Inkeeper dead")


func _on_TileGrid_turn_ended(activations):
	#User deals damage
	$MonsterSpawn.get_child(0).update_health(4)
	previous_turn = turn_count
	turn_count += 1
	emit_signal("turn_start")


func monster_turn():
	if CurrentMonster.current_move_type == "Damage":
		update_IK_health(CurrentMonster.current_move_value)
	CurrentMonster.next_attack()
	previous_turn = turn_count
