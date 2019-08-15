extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Bomb_body_entered(body):
	if body.has_method("hit_by_projectile"):
		body.call("hit_by_projectile")
	var explosionParticles = preload("res://scenes/particles/explosion_particles.tscn").instance()	
	explosionParticles.position = self.global_position
	get_parent().add_child(explosionParticles)	
	queue_free()
