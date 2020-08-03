extends Node2D

onready var monsterDB = get_node("/root/MonsterDB")


var id = ""
var Health = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var m = monsterDB.get_monster(id)
	$Sprite.texture = load(m["Sprite"])
	Health = m["Health"]
	set_label()


func set_label():
	#Health
	$Health/Label.text = str(Health)
	$Health/AnimationPlayer.play("HealthHover")
	

func update_health(amount):
	Health = Health - amount
	$Health/AnimationPlayer.play("TakeDamage")
	is_dead()
	#KAIIIBA
	$Health/AudioStreamPlayer.set_stream(load("res://assets/sound/KAIIIII.wav"))
	$Health/AudioStreamPlayer.play()
	#END_KAIIIBA
	
	yield($Health/AudioStreamPlayer,"finished")
	set_label()
	
	
	#KAIIIBA
	$Health/AudioStreamPlayer.set_stream(load("res://assets/sound/BAAAA.wav"))
	$Health/AudioStreamPlayer.play()
	#END_KAIIIBA
	
	

func is_dead():
	if Health <= 0:
		queue_free()
