extends Control

signal item_selected(item,id)

onready var tooltip = load("res://ToolTip.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var id
var item
#Tooltip
var mouse_tt_hover = 0
var hover_time = 0
var tt_spawned = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	item = ItemDb.get_item(id)
	$Sprite.texture = load(item["Sprite"])
	$Cost.text = str(item["Cost"])

func _process(delta):
		#Handle TT spawn
	if mouse_tt_hover == 1:
		hover_time += delta
		if hover_time > 1 and tt_spawned == 0:
			#Spawn Tooltip
			
			var tt = tooltip.instance()
			tt.get_node("Label").text = item["Tooltip"]
			$Tooltip.add_child(tt)
			tt_spawned = 1
			
			
	if mouse_tt_hover == 0:
		#Despawn Tooltip
		if $Tooltip.get_child_count()>0:
			$Tooltip.get_child(0).queue_free()
			tt_spawned = 0
			hover_time = 0 	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_mouse_entered():
	mouse_tt_hover = 1
	hover_time = 0
	

func _on_TextureButton_mouse_exited():
	mouse_tt_hover = 0


func _on_TextureButton_button_up():
	emit_signal("item_selected", self, id)
