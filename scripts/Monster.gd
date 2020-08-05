extends Node2D

onready var monsterDB = get_node("/root/MonsterDB")
onready var monsterAttacks = monsterDB.MONSTER_ATTACKS

onready var tooltip = load("res://Tooltip.tscn")
onready var attackSprite = $STATS/Attack/attack_icon
onready var healthBar = $STATS/Health/TextureProgress



var random = RandomNumberGenerator.new()

var id = "slime"

var Moves = []

#Move Handling
var current_move
var current_move_type
var current_move_value
var next_move_i

#Stats
var Health = 0
var rage = 0
var armor = 0

#Tooltip
var mouse_tt_hover = 0
var hover_time = 0
var tt_spawned = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#Initialize the monster
	var m = monsterDB.get_monster(id)
	$Sprite.texture = load(m["Sprite"])
	Moves = m["AttackLoop"]
	Health = m["Health"]
	healthBar.max_value = Health
	healthBar.value = Health
	set_label()
	
	
	random.randomize()
	var i = random.randi_range(0,len(Moves)-1)
	attack_step(i)

func _process(delta):
	
	#Handle TT spawn
	if mouse_tt_hover == 1:
		hover_time += delta
		if hover_time > 1 and tt_spawned == 0:
			#Spawn Tooltip
			
			var tt = tooltip.instance()
			tt.get_node("Label").text = monsterAttacks[current_move_type]["Tooltip"]
			$STATS/Attack/TooltipPosition.add_child(tt)
			tt_spawned = 1
			
			
	if mouse_tt_hover == 0:
		#Despawn Tooltip
		
		if $STATS/Attack/TooltipPosition.get_child_count()>0:
			$STATS/Attack/TooltipPosition.get_child(0).queue_free()
			tt_spawned = 0
		hover_time = 0 	


func set_label():
	#Health
	$STATS/Health/Label.text = str(Health)
	$STATS/AnimationPlayer.play("HealthHover")
	

func update_health(amount):
	Health = Health - amount
	$STATS/AnimationPlayer.play("TakeDamage")
	maybe_dead()
	
	#KAIIIBA
	$STATS/Health/AudioStreamPlayer.set_stream(load("res://assets/sound/KAIIIII.wav"))
	$STATS/Health/AudioStreamPlayer.play()
	#END_KAIIIBA
	
	yield($STATS/Health/AudioStreamPlayer,"finished")
	set_label()
	
	
	#KAIIIBA
	$STATS/Health/AudioStreamPlayer.set_stream(load("res://assets/sound/BAAAA.wav"))
	$STATS/Health/AudioStreamPlayer.play()
	#END_KAIIIBA
	
	$STATS/Health/TextureProgress.value = Health
	

func maybe_dead():
	if Health <= 0:
		queue_free()

func attack_step(i):
	current_move = Moves[i]
	#Move value
	current_move_value = current_move["Value"]
	if current_move_value:
		$STATS/Attack/Label.text = str(current_move_value)
	else:
		$STATS/Attack/Label.text = str("")
	#Move Type
	current_move_type = current_move["Move_Type"]
	attackSprite.texture = load(monsterAttacks[current_move_type]["Sprite"])
	#print(monsterAttacks)

	next_move_i = current_move["Next_Move"]
	

func next_attack():
	attack_step(next_move_i)



func _on_Control_mouse_entered():
	mouse_tt_hover = 1
	hover_time = 0
	
	

func _on_Control_mouse_exited():
	mouse_tt_hover = 0
