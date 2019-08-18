extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var currentLevel = 0
var playerScore = 0
export (int) var playerLives = 5
var sessionHighScore = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func decrementPlayerLives():
	playerLives -= 1
	if playerLives == 0:
		_game_over()
	
func _game_over():
	if sessionHighScore < playerScore:
		sessionHighScore = playerScore
		
	get_tree().change_scene("res://scenes/Game_Over.tscn")

func reset():
	playerLives = 5
	currentLevel = 0
	playerScore = 0