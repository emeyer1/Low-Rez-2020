extends Node2D

var audio_cache = {}
func _ready():
	visible = false

func play_attack(attack_type):
	visible = true
	print(attack_type)
	var audio_stream;
	match attack_type:
		"autoAttack":
			$AnimatedSprite.play("autoAttack")
			audio_stream = _get_audio_stream("res://assets/attacks/basicAttack.wav")
		"fire":
			$AnimatedSprite.play("fire")
			audio_stream = _get_audio_stream("res://assets/attacks/fire.wav")
		"slime":
			$AnimatedSprite.play("slime")
			audio_stream = _get_audio_stream("res://assets/attacks/slime.wav")
		"shade":
			$AnimatedSprite.play("shade")
			audio_stream = _get_audio_stream("res://assets/attacks/shade.wav")
		"monsterBasic":
			$AnimatedSprite.play("monsterBasic")
			audio_stream = _get_audio_stream("res://assets/attacks/monsterBasic.wav")
		"rage":
			$AnimatedSprite.play("rage")
			audio_stream = _get_audio_stream("res://assets/attacks/rage.wav")
		"heal":
			$AnimatedSprite.play("heal")
			audio_stream = _get_audio_stream("res://assets/attacks/heal.wav")
		"frost":
			$AnimatedSprite.play("frost")
			audio_stream = _get_audio_stream("res://assets/attacks/frost.wav")
		"mirror":
			$AnimatedSprite.play("mirror")
			audio_stream = _get_audio_stream("res://assets/attacks/mirror.wav")
		"block":
			$AnimatedSprite.play("block")
			audio_stream = _get_audio_stream("res://assets/attacks/block.wav")
	$AudioStreamPlayer.set_stream(audio_stream)
	$AudioStreamPlayer.play(0)
	yield($AnimatedSprite, "animation_finished")
	visible = false
	$AnimatedSprite.stop()
	$AnimatedSprite.set_frame(0)
	return true

func _get_audio_stream(stream_name):
	if(!audio_cache.has(stream_name)):
		audio_cache[stream_name] = ResourceLoader.load(stream_name)
		
	return audio_cache[stream_name]
