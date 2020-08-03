extends Node2D

onready var monsterDB = get_node("/root/MonsterDB")


export var monster = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	var m = monsterDB.get_monster(monster)
	$Sprite.texture = load(m["Sprite"])
	$Health/Label.text = str(m["Health"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
