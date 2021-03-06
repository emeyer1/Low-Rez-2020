extends Control

signal turn_ended(activations)
signal move_occured()
onready var Deck = get_node("/root/Deck")

const tile_material = preload("res://assets/materials/tile.tres")

#ailment:
var frost = false

var nTiles: Vector2 = Vector2(3, 9)
var size: int = 7
var margin: int = 1
var activation_rows = 2
var tiles = []
var player_turn = true
export var moves = 2
var moves_remaining = moves

var from_tile

func _ready():
	moves_remaining = moves

	for x in range(0, nTiles.x):
		tiles.append([])
		for y in range(0, nTiles.y):
			tiles[x].append(get_next_tile())
			set_tile_position(tiles[x][y], x, y)
			tiles[x][y].button.set_size(Vector2(size, size))
			tiles[x][y].button.connect("button_up", self, "on_button_clicked", [tiles[x][y]])
			var mat = tile_material.duplicate()
			tiles[x][y].button.set_material(mat)
			add_child(tiles[x][y].button)

func get_next_tile():
	var ret = { "button" : TextureButton.new()}
	ret.tileType = Deck.draw_tile()
	ret.button.set_normal_texture(Deck.get_texture(ret.tileType))
	return ret

func on_button_clicked(tile):
	if player_turn:
		var position = null
		for x in range(0, nTiles.x):
			var y = tiles[x].find(tile)
			if y != -1:
				position = Vector2(x, y)
				if tile.button.material.get_shader_param("isSlimed"):
					return
		if position == null:
			print("Error tile could not be found")
		else:
			if from_tile == null:
				print("set position: " + str(position.x) + ", " + str(position.y))
				from_tile = position
				tile.button.get_material().set_shader_param("isSelected", true)
			elif from_tile == position || !is_tile_in_swap_range(position, from_tile):
				print("unset position: " + str(from_tile.x) + ", " + str(from_tile.y))
				tiles[from_tile.x][from_tile.y].button.get_material().set_shader_param("isSelected", false)
				from_tile = null
			else:
				print("swapped: [" + str(from_tile.x) + ", " + str(from_tile.y) + "] [" + str(position.x) + ", " + str(position.y) + "]")
				var temp_tile = tiles[position.x][position.y]
				tiles[position.x][position.y] = tiles[from_tile.x][from_tile.y]
				tiles[from_tile.x][from_tile.y] = temp_tile
				set_tile_position(tiles[position.x][position.y], position.x, position.y)
				set_tile_position(tiles[from_tile.x][from_tile.y], from_tile.x, from_tile.y)
				tiles[position.x][position.y].button.get_material().set_shader_param("isSelected", false)
				from_tile = null
				moves_remaining -= 1
				emit_signal("move_occured")
				if(moves_remaining == 0):
					player_turn = false
					var activations = activate_tiles()
					emit_signal("turn_ended", activations)

func is_tile_in_swap_range(position1, position2):
	var y = int(abs(position1.y - position2.y))
	var x = int(abs(position1.x - position2.x))
	return x <= 1 && y <= 1 && x + y <= 1

func set_tile_position(tile, x, y):
	tile.button.set_position(Vector2(x * size + margin, y * size + margin))

func activate_tiles():
	var activations = []
	
	#get x activations
	for y in range(0, nTiles.y):
		var last_tile = null
		var chain = 1
		var activated_tiles = []
		for x in range(0, nTiles.x):
			if tiles[x][y].tileType == last_tile:
				chain += 1
				activated_tiles.append({"x": x, "y": y})
			else:
				if chain >= 3:
					activations.append({"tileType": last_tile, "x" : x - chain, "y": y, "direction": "x", "length": chain, "activated_tiles": activated_tiles})
				last_tile = tiles[x][y].tileType
				chain = 1
				activated_tiles = []
				activated_tiles.append({"x": x, "y": y})
		if chain >= 3:
			activations.append({"tileType": last_tile, "x" :  nTiles.x - chain, "y":y , "direction": "x", "length": chain, "activated_tiles": activated_tiles})
		last_tile = null
	
	#get y activations
	for x in range(0, nTiles.x):
		var last_tile = null
		var chain = 1
		var activated_tiles = []
		for y in range(0, nTiles.y):
			if tiles[x][y].tileType == last_tile:
				chain += 1
				activated_tiles.append({"x": x, "y": y})
			else:
				if chain >= 3:
					activations.append({"tileType": last_tile, "x" : x, "y": y - chain, "direction": "y", "length": chain, "activated_tiles": activated_tiles})
				last_tile = tiles[x][y].tileType
				chain = 1
				activated_tiles = []
				activated_tiles.append({"x": x, "y": y})
		if chain >= 3:
			activations.append({"tileType": last_tile, "x" : x, "y": nTiles.y - chain, "direction": "y", "length": chain, "activated_tiles": activated_tiles})
		last_tile = null
		
	print("activations: " + str(activations))
	return activations

func set_mouse_input(mouse_input_mode):
	for x in range(0, nTiles.x):
		for y in range(0, nTiles.y):
			tiles[x][y].button.mouse_filter = mouse_input_mode

func _on_Main_turn_start():
	for x in range(0, nTiles.x):
		for y in range(0, nTiles.y):
			Deck.discard_tile(tiles[x][y].tileType)
	for x in range(0, nTiles.x):
		for y in range(0, nTiles.y):
			tiles[x][y].tileType = Deck.draw_tile()
			tiles[x][y].button.set_normal_texture(Deck.get_texture(tiles[x][y].tileType))
	yield(drop_in_tiles(), "completed")
	player_turn = true
	if Deck.items.has("flute"): 
		moves_remaining = moves + 1
	else:
		moves_remaining = moves
	
	if frost:
		moves_remaining = moves_remaining - 1
		frost = false
	enable_input()
	
func _on_Main_shop_start():
	for x in range(0, nTiles.x):
		for y in range(0, nTiles.y):
			Deck.discard_tile(tiles[x][y].tileType)
	for y in range(0, nTiles.y):
		for x in range(0, nTiles.x):
			tiles[x][y].tileType = Deck.draw_in_order()
			tiles[x][y].button.set_normal_texture(Deck.get_texture(tiles[x][y].tileType))
	yield(drop_in_tiles(), "completed")
	
func _on_currency_updated(currency):
	for x in range(0, nTiles.x):
		for y in range(0, nTiles.y):
			Deck.discard_tile(tiles[x][y].tileType)
	Deck.reshuffle_discard()
	for y in range(0, nTiles.y):
		for x in range(0, nTiles.x):
			tiles[x][y].tileType = Deck.draw_in_order()
			tiles[x][y].button.set_normal_texture(Deck.get_texture(tiles[x][y].tileType))
	show_tiles()
	
func hide_tiles():
	for x in range(0, nTiles.x):
		for y in range(0, nTiles.y):
			tiles[x][y].button.get_material().set_shader_param("burnAmount", 1)

func show_tiles():
	for x in range(0, nTiles.x):
		for y in range(0, nTiles.y):
			tiles[x][y].button.get_material().set_shader_param("burnAmount", 0)

func hide_tiles_burn():
	var tween = Tween.new()
	add_child(tween)
	for x in range(0, nTiles.x):
		for y in range(0, nTiles.y):
			tween.interpolate_property(
				tiles[x][y].button.get_material(),
				"shader_param/burnAmount",
				0.0, 1.0, .8, Tween.TRANS_LINEAR, Tween.EASE_OUT
			)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.queue_free()
	return true
	
func drop_in_tiles():
	var tween = Tween.new()
	add_child(tween)
	for x in range(0, nTiles.x):
		for y in range(0, nTiles.y):
			var pos = tiles[x][y].button.get_position()
			tiles[x][y].button.get_material().set_shader_param("burnAmount", 0)
			tiles[x][y].button.set_position(Vector2(-10,-10))
			tween.interpolate_method(
				tiles[x][y].button, "set_position", Vector2(pos.x, -6), pos, .2,
				Tween.TRANS_LINEAR, Tween.EASE_IN, x * .05 + (nTiles.y - y) * .15
			)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.queue_free()
	return true

func disable_input():
	for x in range(0, nTiles.x):
		for y in range(0, nTiles.y):
				tiles[x][y].button.set_disabled(true)
				
func enable_input():
	for x in range(0, nTiles.x):
		for y in range(0, nTiles.y):
				tiles[x][y].button.set_disabled(false)

