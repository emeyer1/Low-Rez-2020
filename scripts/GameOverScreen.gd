extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var once = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func mainMenu():
	get_tree().paused = false
	get_tree().change_scene("res://MainMenu.tscn")


func _on_Button_button_down():
	if !once:
		once = true
		print("pressed")
		mainMenu()


func _on_Button2_button_down():
	if !once:
		once = true
		restart()

func restart():
	get_tree().paused = false
	get_tree().reload_current_scene()
