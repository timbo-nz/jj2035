extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/FinalScore/ScoreCount.text = String(GameController.playerScore)
	$VBoxContainer/HighScore/HiScoreValue.text = String(GameController.sessionHighScore)
	
	if GameController.victoryBool:
		$VBoxContainer/Title.text = "VICTORY IS YOURS"


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
	pass # Replace with function body.
