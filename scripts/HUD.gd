extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var objectiveNameArray = ["Bomber", "Oil Tank", "Red Skull"]

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/LivesBar/livesCount.text = String(GameController.playerLives)
	$VBoxContainer/HBoxContainer/scoreCount.text = String(GameController.playerScore)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_update_hud_score():
	$VBoxContainer/HBoxContainer/scoreCount.text = String(GameController.playerScore)


func _on_Player_update_hud_mission_status_text(objectivesLeft):
	if objectivesLeft > 1:
		var objString = String(objectivesLeft)
		$VBoxContainer/MissionStatus/MissionStatusLabel.text = (objString + " " + objectiveNameArray[GameController.currentLevel] + "s left.")
	elif objectivesLeft == 1:
		var objString = String(objectivesLeft)
		$VBoxContainer/MissionStatus/MissionStatusLabel.text = (objString + " " + objectiveNameArray[GameController.currentLevel] + " left.")	
	else: 		
		$VBoxContainer/MissionStatus/MissionStatusLabel.text = ("Mission Complete! Return to Base!")


func _on_Player_update_hud_num_lives(numLives):
	$VBoxContainer/LivesBar/livesCount.text = String(numLives)
