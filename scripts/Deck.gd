extends Node
	
var random = RandomNumberGenerator.new()
var textures = {}

func _ready():
	random.randomize()

var items = [
	
]

var deck = [
	{"tileType": "earth",
		"count": 4},
	{"tileType": "fire",
		"count": 4},
	{"tileType": "empty",
		"count": 11},
	{"tileType": "autoAttack",
		"count": 8}
]

var inplay = [
	{"tileType": "earth",
		"count": 0},
	{"tileType": "fire",
		"count": 0},
	{"tileType": "empty",
		"count": 0},
	{"tileType": "autoAttack",
		"count": 0}
]

var discard = [
	{"tileType": "earth",
		"count": 0},
	{"tileType": "fire",
		"count": 0},
	{"tileType": "empty",
		"count": 0},
	{"tileType": "autoAttack",
		"count": 0}
]

func draw_tile():
	return draw_tile_helper(false)

func draw_tile_helper(tried):
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
	elif !tried:
		reshuffle_discard()
		ret = draw_tile_helper(true)
	else:
		print("Error reshuffling cards")
	return ret

func reshuffle_discard():
	for discard_tile in discard:
		var deck_tile = get_tile(deck, discard_tile.tileType)
		deck_tile.count += discard_tile.count
		discard_tile.count = 0

func discard_all():
	for inplay_tile in inplay:
		get_tile(discard, inplay_tile.tileType).count += inplay_tile.count
		inplay_tile.count = 0

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
			"autoAttack":
				texture = load("res://assets/tiles/autoattack.png")
				
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

func add_item(item_id):
#	get_tile(deck, "empty").count -= ItemDb.get_item(item_id)["Area"]
	items.append(item_id)

func add_tile(tileType):
	get_tile(deck, tileType).count += 1

func remove_tile(tileType):
	get_tile(deck,tileType).count -= 1
