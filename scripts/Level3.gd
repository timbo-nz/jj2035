extends Node

signal update_score
signal update_mission_status_text

var WIN_STATE = false

onready var player = $Player
onready var red_skull = $RedSkull

var objective_count = 0
export (int) var needed_to_win

var activeEnemies =  5


# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("update_mission_status_text", needed_to_win)
	emit_signal("update_score")
	red_skull.connect("minus_enemy_count", self, "_minus_enemy_count")

func _process(delta):
	_check_win()
	if player.position.x > 6000:
		player.position.x = 0
	if player.position.x < 0:
		player.position.x = 6000
	if player.position.y < 0:
		player.position.y = 0
		
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
		GameController.playerScore += 75
	if type == "JET":
		GameController.playerScore += 50
	if type == "TANK":
		GameController.playerScore += 50
	emit_signal("update_score")
	activeEnemies -= 1		

func _on_Base_base_entered():
	print(WIN_STATE)
	if WIN_STATE:
		get_tree().change_scene("res://scenes/levels/Level_1_Mission_Screen.tscn")

