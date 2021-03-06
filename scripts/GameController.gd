extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var currentLevel = 0
var playerScore = 0
export (int) var playerLives = 5
var sessionHighScore = 0
var victoryBool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.play()
	pass # Replace with function body.

func _process(delta):
	if sessionHighScore < playerScore:
		sessionHighScore = playerScore

func decrementPlayerLives():
	playerLives -= 1
	if playerLives == 0:
		_game_over()
	
func _game_over():
	get_tree().change_scene("res://scenes/Game_Over.tscn")

func reset():
	playerLives = 5
	currentLevel = 0
	playerScore = 0
	victoryBool = false