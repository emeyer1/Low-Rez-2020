extends Node2D

onready var monsterDB = get_node("res://MonsterDB")


export var monster = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	var m = MonsterDB.get_monster(monster)
	$Sprite.texture = load(m["Sprite"])
	$Health.text = str(m["Health"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
