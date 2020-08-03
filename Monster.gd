extends Node2D

onready var monsterDB = get_node("/root/MonsterDB")


var id = ""
var Health = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var m = monsterDB.get_monster(id)
	$Sprite.texture = load(m["Sprite"])
	Health = m["Health"]
	$Health/Label.text = str(Health)


func update_health(amount):
	Health = Health - amount
	$Health/Label.text = str(Health)
	is_dead()

func is_dead():
	if Health <= 0:
		queue_free()
