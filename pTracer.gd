extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$trail.emitting = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Tracer_body_entered(body):
	if body.has_method("hit_by_projectile"):
		body.call("hit_by_projectile")
		
	queue_free()