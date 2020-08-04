extends Node2D

onready var monsterDB = get_node("/root/MonsterDB")
onready var attackSprite = $STATS/Attack/attack_icon
onready var healthBar = $STATS/Health/TextureProgress

onready var monsterAttacks = monsterDB.MONSTER_ATTACKS

var random = RandomNumberGenerator.new()

var id = "slime"

var Moves = []

#Move Handling
var current_move
var current_move_type
var current_move_value
var next_move_i

#Stats
var Health = 0
var rage = 0
var armor = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	#Initialize the monster
	var m = monsterDB.get_monster(id)
	$Sprite.texture = load(m["Sprite"])
	Moves = m["AttackLoop"]
	Health = m["Health"]
	healthBar.max_value = Health
	healthBar.value = Health
	set_label()
	
	
	random.randomize()
	var i = random.randi_range(0,len(Moves)-1)
	attack_step(i)


func set_label():
	#Health
	$STATS/Health/Label.text = str(Health)
	$STATS/AnimationPlayer.play("HealthHover")
	

func update_health(amount):
	Health = Health - amount
	$STATS/AnimationPlayer.play("TakeDamage")
	maybe_dead()
	
	#KAIIIBA
	$STATS/Health/AudioStreamPlayer.set_stream(load("res://assets/sound/KAIIIII.wav"))
	$STATS/Health/AudioStreamPlayer.play()
	#END_KAIIIBA
	
	yield($STATS/Health/AudioStreamPlayer,"finished")
	set_label()
	
	
	#KAIIIBA
	$STATS/Health/AudioStreamPlayer.set_stream(load("res://assets/sound/BAAAA.wav"))
	$STATS/Health/AudioStreamPlayer.play()
	#END_KAIIIBA
	
	$STATS/Health/TextureProgress.value = Health
	

func maybe_dead():
	if Health <= 0:
		queue_free()

func attack_step(i):
	current_move = Moves[i]
	#Move value
	current_move_value = current_move["Value"]
	if current_move_value:
		$STATS/Attack/Label.text = str(current_move_value)
	else:
		$STATS/Attack/Label.text = str("")
	#Move Type
	current_move_type = current_move["Move_Type"]
	attackSprite.texture = load(monsterAttacks[current_move_type])
	#print(monsterAttacks)

	next_move_i = current_move["Next_Move"]
	

func next_attack():
	attack_step(next_move_i)
