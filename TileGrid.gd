extends Control

var nTiles: Vector2 = Vector2(3, 7)
var size: int = 7
var margin:int = 1
var tiles
var random = RandomNumberGenerator.new()

var texture = preload("res://16.png")

func _ready():
	random.randomize()
	
	tiles = []
	for x in range(0, nTiles.x):
		tiles.append([])
		for y in range(0, nTiles.y):
			tiles[x].append(draw_tile())
			tiles[x][y].set_position(Vector2(x * (size + margin) + margin, y * (size + margin) + margin))
			tiles[x][y].set_size(Vector2(size, size))
			tiles[x][y].connect("button_up", self, "on_button_clicked", [Vector2(x,y)])
			add_child(tiles[x][y])

func draw_tile():
	var ret = TextureButton.new()
	ret.set_normal_texture(texture)
	return ret

func on_button_clicked(position):
	print(position)
