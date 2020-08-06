extends Control

signal turn_ended(activations)

var nTiles: Vector2 = Vector2(3, 9)
var size: int = 7
var margin: int = 1
var activation_rows = 2
var tiles = []
var random = RandomNumberGenerator.new()
var tile_texture_path = "res://assets/tiles/"
var tile_material = preload("res://assets/materials/selected.tres")
var textures = {}
var player_turn = true
var moves = 2
var moves_remaining = 2

var from_tile

func _ready():
	random.randomize()
	get_textures()

	for x in range(0, nTiles.x):
		tiles.append([])
		for y in range(0, nTiles.y):
			tiles[x].append(get_next_tile())
			set_tile_position(tiles[x][y], x, y)
			tiles[x][y].button.set_size(Vector2(size, size))
			tiles[x][y].button.connect("button_up", self, "on_button_clicked", [tiles[x][y]])
#			tiles[x][y].set_material(tile_material)
			add_child(tiles[x][y].button)

func get_next_tile():
	var ret = { "button" : TextureButton.new()}
	var texture
	match random.randi_range(0, 3):
		0:
			texture = textures["earthblock"]
			ret.tileType = "earthblock"
		1:
			texture = textures["fireblock"]
			ret.tileType = "fireblock"
		2:
			texture = textures["block2"]
			ret.tileType = "block2"
		3:
			texture = textures["block2"]
			ret.tileType = "block2"
	ret.button.set_normal_texture(texture)
	return ret

func on_button_clicked(tile):
	if player_turn:
		var position = null
		for x in range(0, tiles.size()):
			var y = tiles[x].find(tile)
			if y != -1:
				position = Vector2(x, y)
		if position == null:
			print("Error tile could not be found")
		else:
			if from_tile == null:
				print("set position: " + str(position.x) + ", " + str(position.y))
				from_tile = position
			elif from_tile == position || !is_tile_in_swap_range(position, from_tile):
				print("unset position: " + str(from_tile.x) + ", " + str(from_tile.y))
				from_tile = null
			else:
				print("swapped: [" + str(from_tile.x) + ", " + str(from_tile.y) + "] [" + str(position.x) + ", " + str(position.y) + "]")
				var temp_tile = tiles[position.x][position.y]
				tiles[position.x][position.y] = tiles[from_tile.x][from_tile.y]
				tiles[from_tile.x][from_tile.y] = temp_tile
				set_tile_position(tiles[position.x][position.y], position.x, position.y)
				set_tile_position(tiles[from_tile.x][from_tile.y], from_tile.x, from_tile.y)
				from_tile = null
				moves_remaining -= 1
				if(moves_remaining == 0):
					player_turn = false
					var activations = activate_tiles()
					emit_signal("turn_ended", activations)

func is_tile_in_swap_range(position1, position2):
	var y = int(abs(position1.y - position2.y))
	var x = int(abs(position1.x - position2.x))
	return x <= 1 && y <= 1 && x + y <= 1

func get_textures():
	var dir = Directory.new()
	dir.open(tile_texture_path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		elif !file_name.begins_with(".") && !".import" in file_name:
			textures[file_name.replace(".png", "")] = load(tile_texture_path + file_name)
	dir.list_dir_end()

func set_tile_position(tile, x, y):
	tile.button.set_position(Vector2(x * size + margin, y * size + margin))

func activate_tiles():
	var activations = []
	
	#get x activations
	for y in range(0, nTiles.y):
		var last_tile = null
		var chain = 1
		for x in range(0, nTiles.x):
			if tiles[x][y].tileType == last_tile:
				chain += 1
			else:
				if chain >= 3:
					activations.append({"tileType": last_tile, "x" : x - chain, "y": y, "direction": "x", "length": chain})
				last_tile = tiles[x][y].tileType
				chain = 1
		if chain >= 3:
			activations.append({"tileType": last_tile, "x" :  nTiles.x - chain, "y":y , "direction": "x", "length": chain})
		last_tile = null
	
	#get y activations
	for x in range(0, nTiles.x):
		var last_tile = null
		var chain = 1
		for y in range(0, nTiles.y):
			if tiles[x][y].tileType == last_tile:
				chain += 1
			else:
				if chain >= 3:
					activations.append({"tileType": last_tile, "x" : x, "y": y - chain, "direction": "y", "length": chain})
				last_tile = tiles[x][y].tileType
				chain = 1
		if chain >= 3:
			activations.append({"tileType": last_tile, "x" : x, "y": nTiles.y - chain, "direction": "y", "length": chain})
		last_tile = null
		
	print("activations: " + str(activations))
	return activations

func _on_Main_turn_start():
	player_turn = true
	moves_remaining = moves
