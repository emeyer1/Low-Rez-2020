extends Control

signal tutorial_closed()


func _ready():
	$AudioStreamPlayer.set_stream(load("res://assets/sound/page-flip-01a.wav"))
	$Tutorial.visible = false


func _on_Next_button_up():
	if $Tutorial/AnimatedSprite.frame < 3:
		$AudioStreamPlayer.play()
		$Tutorial/AnimatedSprite.frame += 1
	else:
		emit_signal("tutorial_closed")
		self.queue_free()


func _on_Previous_button_up():
	if $Tutorial/AnimatedSprite.frame > 0:
		$AudioStreamPlayer.play()
		$Tutorial/AnimatedSprite.frame -= 1


func _on_TextureButton_button_up():
	$Tutorial.visible = true
	$TextureButton.queue_free()
