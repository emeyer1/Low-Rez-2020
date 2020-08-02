extends Control

var nTiles: Vector2 = Vector2(3, 7)
var size: int = 7
var margin:int = 1
var tiles = []
var random = RandomNumberGenerator.new()
var tile_texture_path = "res://assets/tiles/"
var textures = {}

var from_tile

func _ready():
	random.randomize()
	get_textures()

	for x in range(0, nTiles.x):
		tiles.append([])
		for y in range(0, nTiles.y):
			tiles[x].append(draw_tile())
			tiles[x][y].set_position(Vector2(x * size + margin, y * size + margin))
			tiles[x][y].set_size(Vector2(size, size))
			tiles[x][y].connect("button_up", self, "on_button_clicked", [tiles[x][y]])
			add_child(tiles[x][y])

func draw_tile():
	var ret = TextureButton.new()
	var texture
	match random.randi_range(0, 3):
		0:
			texture = textures["death"]
		1:
			texture = textures["water"]
		2:
			texture = textures["fire"]
		3:
			texture = textures["grass"]
	ret.set_normal_texture(texture)
	return ret

func on_button_clicked(tile):
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
			print("swapped: [" + str(from_tile.x) + ", " + str(from_tile.y) + "][" + str(position.x) + ", " + str(position.y) + "]")
			var temp_tile = tiles[position.x][position.y]
			tiles[position.x][position.y] = tiles[from_tile.x][from_tile.y]
			tiles[from_tile.x][from_tile.y] = temp_tile
			tiles[position.x][position.y].set_position(Vector2(position.x * size + margin, position.y * size + margin))
			tiles[from_tile.x][from_tile.y].set_position(Vector2(from_tile.x * size + margin, from_tile.y * size + margin))
			from_tile = null

func is_tile_in_swap_range(position1, position2):
	var x = int(abs(position1.x - position2.x))
	var y = int(abs(position1.y - position2.y))
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
