extends Node2D

onready var monsterDB = get_node("/root/MonsterDB")
var random = RandomNumberGenerator.new()

var id = "slime"
var Health = 0
var Moves = []
var next_move

# Called when the node enters the scene tree for the first time.
func _ready():
	#Initialize the monster
	var m = monsterDB.get_monster(id)
	$Sprite.texture = load(m["Sprite"])
	Moves = m["Attacks"]
	Health = m["Health"]
	$STATS/Health/TextureProgress.max_value = Health
	$STATS/Health/TextureProgress.value = Health
	set_label()
	load_attack()


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

func load_attack():
	var i = random.randi_range(0,len(Moves)-1)
	print("randi: ",i)
	next_move = Moves[i]
	$STATS/Attack/Label.text = str(next_move)

func attack():
	random.randomize()
	print("Monster Dealt: [",next_move,"]")
	load_attack()
	return next_move
	
