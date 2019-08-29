extends Node2D

onready var scoreCount = $CameraSurrogate/CenterContainer/VBoxContainer/ScoreContainer/scoreValue
onready var hiScoreCount = $CameraSurrogate/CenterContainer/VBoxContainer/hiScoreContainer/scoreValue


# Called when the node enters the scene tree for the first time.
func _ready():
	scoreCount.text = String(GameController.playerScore)
	hiScoreCount.text = String(GameController.sessionHighScore)
	
	if GameController.victoryBool:
		$CameraSurrogate/CenterContainer/VBoxContainer/Title.text = "VICTORY IS YOURS"


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
	pass # Replace with function body.
