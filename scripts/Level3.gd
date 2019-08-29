extends Node

signal update_score
signal update_mission_status_text

var tileSize = 32
var mapSize = 6000
var floorHeight = 1040

var WIN_STATE = false

onready var player = $Player
onready var red_skull = $RedSkull

var objective_count = 0
export (int) var needed_to_win

var activeEnemies =  0
var maxEnemies = 15

onready var redSkull = $RedSkull

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("update_mission_status_text", needed_to_win)
	red_skull.connect("minus_enemy_count", self, "_minus_enemy_count")

func _process(delta):
	_check_win()
	
	_bind_to_map_boundary(player)
	_bind_to_map_boundary(redSkull)
	
func _bind_to_map_boundary(entity):
	if entity.position.x > 6000:
		entity.position.x = 0
	if entity.position.x < 0:
		entity.position.x = 6000
	if entity.position.y < 0:
		entity.position.y = 0
		
func _check_win():
	if objective_count >= needed_to_win:
		WIN_STATE = true
		
func _minus_enemy_count(type):
	if type == "RED_SKULL":
		objective_count += 1
		GameController.playerScore += 1500
		emit_signal("update_mission_status_text", needed_to_win - objective_count)
	if type == "WALKER":
		GameController.playerScore += 100
	if type == "BOMBER":
		GameController.playerScore += 25
	if type == "JET":
		GameController.playerScore += 50
	if type == "TANK":
		GameController.playerScore += 50
	emit_signal("update_score")
	activeEnemies -= 1

func _spawn_enemy():
	if activeEnemies < maxEnemies:
		var rand = rand_range(0,4)
		if rand <= 1:
			_spawn_jet()
		elif rand > 1 && rand <= 2:
			_spawn_bomber()
		elif rand > 2 && rand <= 3:
			_spawn_walker()
		else:
			_spawn_tank()
		print(activeEnemies)	
		

func _spawn_tank():
	activeEnemies += 1
	var tank = preload("res://scenes/enemies/enemyTank.tscn").instance()
	var position = Vector2(rand_range(16, mapSize/tileSize) * tileSize, floorHeight)
	tank.connect("minus_enemy_count", self, "_minus_enemy_count")
	tank.position = position
	add_child(tank)

func _spawn_jet():
	activeEnemies += 1
	var jet = preload("res://scenes/enemies/Enemy_Jet.tscn").instance()
	var position = Vector2(rand_range(0, mapSize/tileSize) * tileSize, rand_range(32, floorHeight - 8 * 32))
	jet.connect("minus_enemy_count", self, "_minus_enemy_count")
	jet.position = position
	jet.linear_velocity = Vector2(rand_range(jet.min_speed, jet.max_speed), 0)
	add_child(jet)

func _spawn_bomber():
	activeEnemies += 1
	var bomber = preload("res://scenes/enemies/Bomber.tscn").instance()
	var position = Vector2(rand_range(0, mapSize/tileSize) * tileSize, rand_range(32, floorHeight - 8 * 32))
	bomber.connect("minus_enemy_count", self, "_minus_enemy_count")
	bomber.position = position	
	bomber.linear_velocity = Vector2(rand_range(bomber.min_speed, bomber.max_speed), 0)
	add_child(bomber)

func _spawn_walker():
	activeEnemies += 1
	var walker = preload("res://scenes/enemies/eWalker.tscn").instance()
	var position = Vector2(rand_range(16, mapSize/tileSize) * tileSize, floorHeight)
	walker.connect("minus_enemy_count", self, "_minus_enemy_count")
	walker.position = position	
	add_child(walker)

func _on_Base_base_entered():
	if WIN_STATE:
		GameController.victoryBool = true
		get_tree().change_scene("res://scenes/Game_Over.tscn")

func _on_spawnTimer_timeout():
	_spawn_enemy()
