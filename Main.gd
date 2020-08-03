extends Node2D

onready var MonsterBase = load("res://Monster.tscn")
var random = RandomNumberGenerator.new()
var monsters = ["slime","orc"]


#Innkeeper Data
var IKhealth = 20
var turn_count = 0
var previous_turn = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_innkeeper()
	spawn_monster("slime")

func _process(delta):
	#Spawn monster when space is open
	random.randomize()
	if $MonsterSpawn.get_child_count()<1:
		#TODO: Get which monsters spawn and then determine a random new one up. Could do a random order to balance?
		var r = random.randi_range(0,1)
		spawn_monster(monsters[r])
		
	#Damage Monster
	if Input.is_action_just_pressed("ui_select"):
		$MonsterSpawn.get_child(0).update_health(3)
		previous_turn = turn_count
		turn_count += 1
	
	if previous_turn != turn_count:
		update_IK_health(1)
		previous_turn = turn_count
	#Monster Damages 
	
	
func initialize_innkeeper():
	$UI/health_icon/InnkeeperHealth.text = str(IKhealth)

func spawn_monster(value):
	var Monster = MonsterBase.instance()
	Monster.id = value
	$MonsterSpawn.add_child(Monster)

func update_IK_health(amount):
	IKhealth = IKhealth - amount
	$UI/health_icon/InnkeeperHealth.text = str(IKhealth)
	is_IK_dead()
	
func is_IK_dead():
	if IKhealth <= 0:
		#Gameover screen goes here
		print("Inkeeper dead")
