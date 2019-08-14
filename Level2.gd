extends Node

signal update_score
signal update_mission_status_text

onready var player = $Player

var tileSize = 32
var mapSize = 6000
var floorHeight = 1024

export (int) var needed_to_win = 5

var WIN_STATE = false
var obj_to_place = 5
var objective_count = 0

export (int) var maxEnemies = 10
var activeEnemies = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_objectives()
	_spawn_intial_enemies(3)
	emit_signal("update_mission_status_text", needed_to_win)
	emit_signal("update_score", GameController.playerScore)
	pass # Replace with function body.

func _spawn_objectives():	
	while obj_to_place > 0:
		var oilTank = preload("res://oilTank.tscn").instance()
		var position = Vector2(rand_range(32, mapSize/tileSize) * tileSize, floorHeight)
		oilTank.connect("minus_enemy_count", self, "_minus_enemy_count")
		oilTank.position = position
		add_child(oilTank)
		
		var aaGun = preload("res://AA.tscn").instance()
		var pos = Vector2(oilTank.position.x + 64, oilTank.position.y)
		aaGun.position = pos
		add_child(aaGun)
		obj_to_place -= 1

func _spawn_intial_enemies(numToSpawn):
	for i in numToSpawn:
		_spawn_jet()
		_spawn_tank()

func _spawn_tank():
	activeEnemies += 1
	var tank = preload("res://enemyTank.tscn").instance()
	var position = Vector2(rand_range(16, mapSize/tileSize) * tileSize, floorHeight)
	tank.connect("minus_enemy_count", self, "_minus_enemy_count")
	tank.position = position
	add_child(tank)

func _spawn_jet():
	activeEnemies += 1
	var jet = preload("res://Enemy_Jet.tscn").instance()
	var position = Vector2(rand_range(0, mapSize/tileSize) * tileSize, rand_range(32, floorHeight - 8 * 32))
	jet.connect("minus_enemy_count", self, "_minus_enemy_count")
	jet.position = position
	jet.linear_velocity = Vector2(rand_range(jet.min_speed, jet.max_speed), 0)
	add_child(jet)

func _spawn_bomber():
	activeEnemies += 1
	var bomber = preload("res://Bomber.tscn").instance()
	var position = Vector2(rand_range(0, mapSize/tileSize) * tileSize, rand_range(32, floorHeight - 8 * 32))
	bomber.connect("minus_enemy_count", self, "_minus_enemy_count")
	bomber.position = position	
	bomber.linear_velocity = Vector2(rand_range(bomber.min_speed, bomber.max_speed), 0)
	add_child(bomber)
	
func _check_win():
	if objective_count >= needed_to_win:
		WIN_STATE = true
	
func _minus_enemy_count(type):
	if type == "OIL_TANK":
		objective_count += 1
		GameController.playerScore += 100
		emit_signal("update_mission_status_text", needed_to_win - objective_count)
	if type == "BOMBER":
		GameController.playerScore += 75
	if type == "JET":
		GameController.playerScore += 50
	if type == "TANK":
		GameController.playerScore += 50
	emit_signal("update_score")
	activeEnemies -= 1

func _spawn_enemy():
	if activeEnemies < maxEnemies:
		var rand = rand_range(0,3)		
		if rand <= 1:
			_spawn_jet()
		elif rand > 1 && rand <= 2:
			_spawn_bomber()
		else:
			_spawn_tank()

func _process(delta):
	_check_win()
	if player.position.x > 6000:
		player.position.x = 0
	if player.position.x < 0:
		player.position.x = 6000
	if player.position.y < 0:
		player.position.y = 0


func _on_spawnTimer_timeout():
	_spawn_enemy()


func _on_Base_base_entered():
	if WIN_STATE:
		get_tree().change_scene("res://TitleScreen.tscn")

