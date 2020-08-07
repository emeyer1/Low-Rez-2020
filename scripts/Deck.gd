extends Node
	
var random = RandomNumberGenerator.new()
var textures = {}

func _ready():
	random.randomize()

var deck = [
	{"tileType": "earth",
		"count": 40},
	{"tileType": "fire",
		"count": 10},
	{"tileType": "empty",
		"count": 10}
]

var inplay = [
	{"tileType": "earth",
		"count": 0},
	{"tileType": "fire",
		"count": 0},
	{"tileType": "empty",
		"count": 0}
]

var discard = [
	{"tileType": "earth",
		"count": 0},
	{"tileType": "fire",
		"count": 0},
	{"tileType": "empty",
		"count": 0}
]

func draw_tile():
	var ret
	var total_tiles = 0
	for tile in deck:
		total_tiles += tile.count
	
	if total_tiles > 0:
		var selected = random.randi_range(0, total_tiles - 1)
		var counted = 0
		for tile in deck:
			if tile.count > 0:
				if selected < counted + tile.count:
					ret = tile.tileType
					tile.count -= 1
					for play_tile in inplay:
						if play_tile.tileType == tile.tileType:
							play_tile.count += 1
							break
					break
				else:
					counted += tile.count
	else:
		reshuffle_discard()
		ret = draw_tile()
	return ret

func reshuffle_discard():
	print_tiles()
	for discard_tile in discard:
		var deck_tile = get_tile(deck, discard_tile.tileType)
		deck_tile.count += discard_tile.count
		discard_tile.count = 0

func discard_tile(tileType):
	get_tile(inplay, tileType).count -= 1
	get_tile(discard, tileType).count += 1

func get_texture(tileType):
	if textures.has(tileType):
		return textures[tileType]
	else:
		var texture
		match(tileType):
			"earth":
				texture = load("res://assets/tiles/earthblock.png")
			"fire":
				texture = load("res://assets/tiles/fireblock.png")
			"empty":
				texture = load("res://assets/tiles/block2.png")
				
		textures[tileType] = texture
		return textures[tileType]
		
func get_tile(array, tileType):
	var ret
	for tile in array:
		if tile.tileType == tileType:
			ret = tile
			break
	return ret

func print_tiles():
	var s = {"deck": [], "inplay": [], "discard": []}
	for tile in deck:
		if tile.count != 0:
			s.deck.append(tile)
	for tile in inplay:
		if tile.count != 0:
			s.inplay.append(tile)
	for tile in discard:
		if tile.count != 0:
			s.discard.append(tile)
	print(s)
