extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite/smokeParticles.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.position.x > 6000:
		self.position.x = 0
	if self.position.x < 0:
		self.position.x = 6000		
#	pass

func _on_fuze_timeout():
	_explode()

func _on_Missile_body_entered(body):
	if body.has_method("hit_by_projectile"):
		body.call("hit_by_projectile")
	_explode()
	

func _explode():
	var explosionParticles = preload("res://explosion_particles.tscn").instance()
	explosionParticles.position = self.global_position
	get_parent().add_child(explosionParticles)
	queue_free()
