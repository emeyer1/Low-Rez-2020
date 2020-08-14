extends Control

signal tutorial_closed()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Next_button_up():
	if $AnimatedSprite.frame < 3:
		$AnimatedSprite.frame += 1
	else:
		emit_signal("tutorial_closed")
		self.queue_free()


func _on_Previous_button_up():
	if $AnimatedSprite.frame > 0:
		$AnimatedSprite.frame -= 1
