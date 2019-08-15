extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var STATE = "READY"
var STATE_EXPLODED = "STATE_EXPLODED"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite/smokeParticles.emitting = true
	var pitchScale = rand_range(1.2, 1.5)
	$Explosion.set_pitch_scale(pitchScale)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if STATE == STATE_EXPLODED && !$Explosion.playing:
		queue_free()
	if self.position.x > 6000:
		self.position.x = 0
	if self.position.x < 0:
		self.position.x = 6000
	
#	pass

func _on_fuze_timeout():
	if STATE != STATE_EXPLODED:
		_explode()

func _on_Missile_body_entered(body):
	_explode()
	if body.has_method("hit_by_projectile"):
		body.call("hit_by_projectile")
	

func _explode():
	STATE = STATE_EXPLODED
	$Explosion.play()
	remove_child($Hitbox)
	$Sprite.visible = false
	var explosionParticles = preload("res://scenes/particles/explosion_particles.tscn").instance()
	explosionParticles.position = self.global_position
	get_parent().add_child(explosionParticles)