extends Node2D

export (PackedScene) var enemy
export (PackedScene) var tank
export (PackedScene) var bomber
export (int) var leftLimit
export (int) var rightLimit
export (int) var maxEnemies
export (int) var needed_to_win = 5

signal update_score
signal update_mission_status_text

var WIN_STATE = false
var obj_to_place = 5
var objective_count = 0

var activeEnemies = 0
var groundLevel = 1024
var randomNum

onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	randomNum = RandomNumberGenerator.new()
	randomNum.randomize()
	_spawn_objective()
	emit_signal("update_mission_status_text", needed_to_win - objective_count)
	pass # Replace with function body.

func check_win():
	if objective_count >= needed_to_win:
		WIN_STATE = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_win()
	
	if player.position.x > 6000:
		player.position.x = 0
	if player.position.x < 0:
		player.position.x = 6000
	if player.position.y < 0:
		player.position.y = 0

	

func _decrement_enemies(type):
	if type == "TANK":
		GameController.playerScore += 25
	if type == "JET":	
		GameController.playerScore += 50
	activeEnemies -= 1
	if type == "BOMBER":
		GameController.playerScore += 100
		_increment_objective_count()
	emit_signal("update_score")
	
func _increment_objective_count():
	objective_count += 1
	emit_signal("update_mission_status_text", needed_to_win - objective_count)

func _spawn_objective():
	while obj_to_place != 0:
		var mob = bomber.instance()
		mob.connect("minus_enemy_count", self, "_decrement_enemies")
		#left path
		$LeftPath.position = player.position
		$LeftPath/LeftSpawnLoc.position = player.position
		$LeftPath/LeftSpawnLoc.set_offset(randi())
		var direction = $LeftPath/LeftSpawnLoc.rotation + PI / 2
		mob.position = $LeftPath/LeftSpawnLoc.position
		direction += rand_range(-PI / 4, PI / 4)
		mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
		add_child(mob)
		obj_to_place -= 1

func _spawn_enemy():
	var b = randomNum.randi_range(1, 100)
	if (b <= 75):
		var mob = enemy.instance()		
		mob.connect("minus_enemy_count", self, "_decrement_enemies")
		$LeftPath.position = player.position
		$LeftPath/LeftSpawnLoc.position = player.position
		$LeftPath/LeftSpawnLoc.set_offset(randi())
		var direction = $LeftPath/LeftSpawnLoc.rotation + PI / 2
		mob.position = $LeftPath/LeftSpawnLoc.position
		direction += rand_range(-PI / 4, PI / 4)
		mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
		add_child(mob)		
		
	else:
		var mob = tank.instance()
		mob.connect("minus_enemy_count", self, "_decrement_enemies")
		$RightPath/RightSpawnLoc.set_offset(randi())
		var direction = $RightPath/RightSpawnLoc.rotation + PI / 2
		mob.position = $RightPath/RightSpawnLoc.position
		direction += rand_range(-PI / 4, PI / 4)
		add_child(mob)

func _spawn_tank():
	var mob = tank.instance()
	mob.position = Vector2(100, 1040)
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	add_child(mob)

func _on_SpawnTimer_timeout():	
	if (activeEnemies < maxEnemies):
		activeEnemies += 1
		_spawn_enemy()

func _on_Base_base_entered():
	if WIN_STATE:
		get_tree().change_scene("res://scenes/levels/Level_2_Mission_Screen.tscn")
	else:
		print(String(needed_to_win - objective_count) + " bombers left.")
	pass # Replace with function body.


func _on_Base_base_exited():
	pass # Replace with function body.
