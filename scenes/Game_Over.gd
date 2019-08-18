extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/FinalScore/ScoreCount.text = String(GameController.playerScore)
	$VBoxContainer/HighScore/HiScoreValue.text = String(GameController.sessionHighScore)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		get_tree().change_scene("res://scenes/levels/Level_1_Mission_Screen.tscn")