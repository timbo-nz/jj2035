extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var STATE = "READY"
var STATE_EXPLODED = "STATE_EXPLODED"

# Called when the node enters the scene tree for the first time.
func _ready():
	var pitchScale = rand_range(0.2, 0.6)
	$Explosion.set_pitch_scale(pitchScale)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if STATE == STATE_EXPLODED && !$Explosion.playing:
		queue_free()


func _on_Bomb_body_entered(body):
	STATE = STATE_EXPLODED
	$Explosion.play()
	remove_child($Hitbox)
	$Sprite.visible = false
	if body.has_method("hit_by_projectile"):
		body.call("hit_by_projectile")
	var explosionParticles = preload("res://scenes/particles/explosion_particles.tscn").instance()	
	explosionParticles.position = self.global_position
	get_parent().add_child(explosionParticles)
	
