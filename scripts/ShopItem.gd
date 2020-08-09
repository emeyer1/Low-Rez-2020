extends Control

signal item_selected(shop_item, item_id)

var id = "error"
var item
func _ready():
	item = ItemDb.get_item(id)
	$Button/ItemSprite.texture = load(item["Sprite"])
	$Button/ItemName.text = item["ItemName"]
	$Button/Cost.text = str(item["Currency"])
	$Button.hint_tooltip = item["Tooltip"]

func _on_Button_button_up():
	emit_signal("item_selected", self, id)
