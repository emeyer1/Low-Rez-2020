extends Node2D

signal item_selected(shop_item, item_id)

var id = "error"
var item
func _ready():
	item = ItemDb.get_item(id)
	$ItemSprite.texture = load(item["Sprite"])
	$ItemName.text = item["ItemName"]
	$Cost.text = str(item["Currency"])


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.pressed:
		match event.button_index:
			BUTTON_LEFT:
				emit_signal("item_selected", self, id)
			
