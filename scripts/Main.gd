extends Node2D

signal turn_start

onready var MonsterBase = load("res://Monster.tscn")
onready var ShopScreen = load("res://Shop.tscn")
onready var TutorialScreen = load("res://Tutorial.tscn")


var random = RandomNumberGenerator.new()
#var monsterSpawnList = ["spiritCouncil","spirit","spiritCouncil","spiritMage","spiritBoss"]
var monsterSpawnList = []
var CurrentMonster
export var power_level = 1

#Innkeeper Data
var IKhealth = 20
var IKhealth_full = IKhealth
var IKhealth_base = IKhealth
var moves_base = 2
var turn_count = 0
var previous_turn = 0
var damage = 0
var armor = 0
var armor_base = 0
var aadmg_base = 0
var IKcurrency = 20
var ailment = null
var currentAilment = null

# Called when the node enters the scene tree for the first time.
func _ready():
	update_stats()
	initialize_innkeeper()
	set_Night()

func _process(delta):
	#Set the swap count remaining
	$UI/swap_icon/Label.text = str($ViewportContainer/Viewport/TileGrid.moves_remaining)
#	print(len(monsterSpawnList))
	#Once turn ends, monster goes. Right now it just uses a random attack amount from the MonsterDB.
	#Handle attacks as a dict that are then matched? Damage:3, Blocks: 5, Row:1, Heal:10 etc.

func set_Tutorial():
	$ViewportContainer/Viewport/TileGrid.hide_tiles()
	$ViewportContainer/Viewport/TileGrid.set_mouse_input(Control.MOUSE_FILTER_IGNORE)
	$ViewportContainer.visible = false
	IKhealth = IKhealth_full
	$UI/health_icon/InnkeeperHealth.text = str(IKhealth)
	armor = max(armor_base,0)
	update_armor()
	
	
	#ANIMATION tutorial
	$Background/Tavern.play("Morning")
	yield($Background/Tavern,"animation_finished")
#	
#	$AudioStreamPlayer.play()
#	yield($AudioStreamPlayer,"finished")
#	$AudioStreamPlayer.play()
	
	
	
	$Background/Tavern.play("MerchantEntrance")
	
	yield($Background/Tavern,"animation_finished")
	#Play idle animation of merchant and yield until dialog is over.
	$Background/Tavern.play("OopsNoMoney")
	yield($Background/Tavern,"animation_finished")
	 
	var tutorial = TutorialScreen.instance()
	tutorial.connect("tutorial_closed",self,"_on_tutorial_closed")
	$ShopPosition.add_child(tutorial)
	yield($ShopPosition.get_child(0),"tutorial_closed")
	$ViewportContainer.visible = true
	$ViewportContainer/Viewport/TileGrid.drop_in_tiles()
	
	$ViewportContainer/Viewport/TileGrid.set_mouse_input(Control.MOUSE_FILTER_STOP)
	
	set_Night()
	
func _on_tutorial_closed():
	pass

func set_Day():
	if power_level == 11:
		#health doesn't reset from previous fight. Last fight is just against a snake.
		$ViewportContainer/Viewport/TileGrid.set_mouse_input(Control.MOUSE_FILTER_IGNORE)
		$Background/Tavern.play("TheFinalMorning")
		yield($Background/Tavern,"animation_finished")
		spawn_monster("slumpoMasterOfAll")
		yield($MonsterSpawn.get_node("Monster/SpriteAnPlayer"),"animation_finished")
		$Background/Tavern.frame = 0
		$Background/Tavern.stop()
		$ViewportContainer/Viewport/TileGrid.set_mouse_input(Control.MOUSE_FILTER_STOP)
	else:
		$ViewportContainer/Viewport/TileGrid.set_mouse_input(Control.MOUSE_FILTER_IGNORE)
		IKhealth = IKhealth_full
		$UI/health_icon/InnkeeperHealth.text = str(IKhealth)
		armor = max(armor_base,0)
		update_armor()
		
		#ANIMATION Morning
		$ViewportContainer/Viewport/TileGrid.set_mouse_input(Control.MOUSE_FILTER_IGNORE)
		$Background/Tavern.play("Morning")
		yield($Background/Tavern,"animation_finished")
		
		#ANIMATION Merchant Enter
		$Background/Tavern.play("MerchantEntrance")
		yield($Background/Tavern,"animation_finished")
		$ViewportContainer/Viewport/TileGrid.set_mouse_input(Control.MOUSE_FILTER_STOP)
		
		#Insert text here for merchant talking
	
		var Shop = ShopScreen.instance()
		Shop.currency = IKcurrency
		Shop.connect("shop_closed", self, "_on_shop_closed")
		Shop.connect("update_currency", self, "_on_currency_updated")
		self.add_child(Shop)

func set_Night():

	
	#Make Merchant Leaving animation
	IKhealth_full = IKhealth
	
	#Merchant says shit
	
	#ANIMATION Merchant Leave
	$ViewportContainer/Viewport/TileGrid.set_mouse_input(Control.MOUSE_FILTER_IGNORE)
	$Background/Tavern.play("MerchantLeave")
	yield($Background/Tavern,"animation_finished")
	#ANIMATION Night
	
	$AudioStreamPlayer.set_stream(load("res://assets/sound/BattleTheme.ogg"))
	$AudioStreamPlayer.play()
	
	$Background/Tavern.play("Night")
	yield($Background/Tavern,"animation_finished")
	$ViewportContainer/Viewport/TileGrid.set_mouse_input(Control.MOUSE_FILTER_STOP)
	
	monsterSpawnList = MonsterDB.get_level_list(power_level).duplicate(true)
	
	spawn_monster(monsterSpawnList[0])
	monsterSpawnList.pop_front()

func _on_shop_closed():
	set_Night()
	$ViewportContainer/Viewport/TileGrid.set_mouse_input(Control.MOUSE_FILTER_STOP)
	emit_signal("turn_start")
	
func _on_currency_updated(currency):
	IKcurrency = min(currency,99)
	$UI/Currency/Label.text = str(IKcurrency)
	update_stats()
	
func initialize_innkeeper():
	$UI/health_icon/InnkeeperHealth.text = str(IKhealth)
	$UI/Currency/Label.text = str(IKcurrency)
	update_armor()

func spawn_monster(value):
	$UI/swap_icon/Label.add_color_override("font_color", Color("fbf236"))
	var Monster = MonsterBase.instance()
	Monster.id = value
	Monster.connect("monster_dead",self,"monster_died")
	$MonsterSpawn.add_child(Monster)
	CurrentMonster = $MonsterSpawn.get_child(0)
	

func monster_died(currency):
	$MonsterSpawn.get_child(0).queue_free()
	IKcurrency = min(currency+IKcurrency,99)
	$UI/Currency/Label.text = str(IKcurrency)
	if len(monsterSpawnList)>0:
		#TODO: Get which monsters spawn and then determine a random new one up. Could do a random order to balance?
		spawn_monster(monsterSpawnList[0])
		monsterSpawnList.pop_front()
		CurrentMonster = $MonsterSpawn.get_child(0)
	if power_level == 11:
		get_tree().change_scene("res://Thanks.tscn")
	else:
		CurrentMonster = null
		power_level += 1
		set_Day()

func update_IK_health(amount):
	var leftover_dmg = max(amount - armor,0)
	armor = max(armor-amount,0) + armor_base
	update_armor()
	IKhealth = IKhealth - leftover_dmg
	$UI/health_icon/InnkeeperHealth.text = str(IKhealth)
	maybe_IK_dead()

func update_armor():
	if armor <= 0:
		$UI/armor_icon.visible = false
	else:
		$UI/armor_icon.visible = true
		$UI/armor_icon/Label.text = str(armor)
	
func maybe_IK_dead():
	if IKhealth <= 0:
		get_tree().paused = true
		var gameOver = load("res://GameOverScreen.tscn").instance()
		add_child(gameOver)

func _on_TileGrid_turn_ended(activations):
	CurrentMonster = $MonsterSpawn.get_child(0)
	var dead = false
	#Handle tile type and activation:
	for i in activations:
		if i["tileType"] == "empty" || (dead && (i["tileType"] == "fire" || i["tileType"] == "autoAttack")):
			continue
		
		set_activated_tiles(i.activated_tiles)
		$ViewportContainer/Viewport/AttackTween.start()
		yield($ViewportContainer/Viewport/AttackTween, "tween_all_completed")
		match i["tileType"]:
			"autoAttack":
				damage += i["length"] * 1
				damage += aadmg_base
				var attack_done = $AttackPlayer.play_attack(i["tileType"])
				yield(attack_done, "completed")
				print("autoAttack for " + str(damage))
			"fire":
				damage += i["length"] * 2
				var attack_done = $AttackPlayer.play_attack(i["tileType"])
				yield(attack_done, "completed")
				print("fire for " + str(damage))
			"earth":
				var new_armor = i["length"] * 1
				#INSERT: Animation for max armor
				armor = min(new_armor + armor,9)
				print("armor for " + str(new_armor))
				
		#User deals damage
		if(!dead):
			dead = $MonsterSpawn.get_child(0).update_health(max(damage-CurrentMonster.blockAmount,0))
		damage = 0
		update_armor()
		unset_activated_tiles(i.activated_tiles)
		
	previous_turn = turn_count
	turn_count += 1
	
	if !dead:
		if CurrentMonster.Health > 0:
			monster_turn()
			
	clear_tile_shader_params()
	yield($ViewportContainer/Viewport/TileGrid.hide_tiles_burn(), "completed")
	emit_signal("turn_start")
	
	if ailment:
		currentAilment = ailment
		var i = 5
		var array : Array = []
		var TileOG = $ViewportContainer/Viewport/TileGrid.tiles
		var TilesVec = TileOG.duplicate(true)
		TilesVec = TilesVec[0]+TilesVec[1]+TilesVec[2]


		while i != 0:
			random.randomize()
			var randNum = random.randi_range(0,len(TilesVec)-1)
			if TilesVec[randNum]["tileType"] != "item":
				print(TilesVec[randNum]["tileType"])
				array.append(TilesVec[randNum]["button"])
				TilesVec.remove(randNum)
				i -= 1

		match ailment:
			"Shade":
				for node_name in array:
					var c = $ViewportContainer/Viewport/TileGrid.get_children()[$ViewportContainer/Viewport/TileGrid.get_children().find(node_name)]
					c.material.set_shader_param("isShade", true)
			"Slime":
				for node_name in array:
					var c = $ViewportContainer/Viewport/TileGrid.get_children()[$ViewportContainer/Viewport/TileGrid.get_children().find(node_name)]
					c.material.set_shader_param("isSlimed", true)
		
		
		ailment = null
	#HandDealt -> Ailment takes effect -> Animation of hand dealt

func set_activated_tiles(tiles):
	for tile in tiles:
		var mat = $ViewportContainer/Viewport/TileGrid.tiles[tile.x][tile.y].button.get_material();
		mat.set_shader_param("isActivated", true)
		$ViewportContainer/Viewport/AttackTween.interpolate_property(
			mat,
			"shader_param/activeAmount",
			.6, 2, 1.5,
			Tween.TRANS_LINEAR, Tween.EASE_OUT
		)

func unset_activated_tiles(tiles):
	for tile in tiles:
		$ViewportContainer/Viewport/TileGrid.tiles[tile.x][tile.y].button.get_material().set_shader_param("isActivated", false)
		$ViewportContainer/Viewport/TileGrid.tiles[tile.x][tile.y].button.get_material().set_shader_param("activeAmount", 0)
		$ViewportContainer/Viewport/AttackTween.remove_all()

func monster_turn():
	$UI/swap_icon/Label.add_color_override("font_color", Color("fbf236"))
	print(CurrentMonster)
	CurrentMonster = $MonsterSpawn.get_child(0)
	print(CurrentMonster)
	match CurrentMonster.current_move_type:
		"Damage":
			update_IK_health(CurrentMonster.current_move_value)
		"Shade":
			ailment = "Shade"
		"Slime":
			ailment = "Slime"
		"Rage":
			CurrentMonster.rage = true	
		"Heal":
			CurrentMonster.update_health(-CurrentMonster.current_move_value)
		"Frost":
			$ViewportContainer/Viewport/TileGrid.frost = true
			$UI/swap_icon/Label.add_color_override("font_color", Color("1bdddd"))
		"Mirror":
			update_IK_health(CurrentMonster.mirror_damage)
		"Block":
			pass #handled in the mosnter script
	CurrentMonster.next_attack()
	previous_turn = turn_count

func clear_tile_shader_params():
	for tile in $ViewportContainer/Viewport/TileGrid.get_children():
		tile.get_material().set_shader_param("isShade", false)
		tile.get_material().set_shader_param("isSlimed", false)

func _on_TileGrid_move_occured():
	if currentAilment == "Shade":
		clear_tile_shader_params()

func update_stats():
	var PlusHealth = 0
	var PlusMoves = 0
	var PlusArmor = 0
	var PlusAAdmg = 0
	for i in Deck.items:
		for j in len(i):
			match i[j].keys()[0]:
				"Health":
					PlusHealth += i[j].values()[0]
				"Move":
					PlusMoves += i[j].values()[0]
				"Armor":
					PlusArmor += i[j].values()[0]
				"AAdmg":
					PlusAAdmg += i[j].values()[0]
	#Health
	IKhealth = IKhealth_base + PlusHealth
	#$UI/health_icon/InnkeeperHealth.text = str(IKhealth)	
	update_IK_health(0)
	
	#moves
	$ViewportContainer/Viewport/TileGrid.moves = moves_base + PlusMoves
	$ViewportContainer/Viewport/TileGrid.moves_remaining = $ViewportContainer/Viewport/TileGrid.moves
	
	#Armor
	armor_base = PlusArmor
	armor = armor_base
	update_armor()
	
	#aadmg
	aadmg_base = PlusAAdmg
