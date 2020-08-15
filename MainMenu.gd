extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var played = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
	
func _process(delta):
	if $AudioStreamPlayer.get_playback_position() > 4 and played == 0:
		played = 1
		$AnimatedSprite.play("default")
		yield($AnimatedSprite,"animation_finished")
		$titlecard.visible = true
		$Button.visible = true
	
	
	if rand_range(1,99)>98.9:
		$AnimatedSprite.play("default")
		yield($AnimatedSprite,"animation_finished")
		$AnimatedSprite.stop()

func _on_Button_button_down():
	get_tree().change_scene("res://Main.tscn")
