extends Node2D

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		_start_game()

func _start_game():
	get_tree().change_scene("res://scenes/Level1.tscn")

func _on_StartButton_pressed():
	_start_game()
