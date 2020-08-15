extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func play_attack(attack_type):
	visible = true
	print(attack_type)
	match attack_type:
		"autoAttack":
			$AnimatedSprite.play("autoAttack")
		"fire":
			$AnimatedSprite.play("fire")
			
	$AudioStreamPlayer.play(0)
	yield($AnimatedSprite, "animation_finished")
	visible = false
	$AnimatedSprite.stop()
	$AnimatedSprite.set_frame(0)
	return true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
