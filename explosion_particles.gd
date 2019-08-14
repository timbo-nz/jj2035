extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$explosionParticles.emitting = true
	$smokeParticles.emitting = true	
	pass # Replace with function body.
