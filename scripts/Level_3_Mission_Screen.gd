extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBarContainer/HBoxContainer2/ScoreValue.text = String(GameController.playerScore)
	GameController.currentLevel = 2
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		_start_game()

func _start_game():
	get_tree().change_scene("res://scenes/levels/Level3.tscn")

func _on_StartButton_pressed():
	_start_game()
