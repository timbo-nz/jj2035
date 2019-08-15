extends RigidBody2D
export (PackedScene) var projectile

signal minus_enemy_count

export var min_speed = 200
export var max_speed = 400

var TYPE = "BOMBER"

var STATE_LIVE = "STATE_LIVE"
var STATE_KILLED = "STATE_KILLED"

var STATE = STATE_LIVE

onready var sprite = $Sprite
onready var hitbox = $Hitbox

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var pitchScale = rand_range(0.85, 1.2)
	$AudioStreamPlayer2D.set_pitch_scale(pitchScale)
	var waitTime = rand_range(2, 6)
	$shotTimer.set_wait_time(waitTime)
	$shotTimer.start()

func hit_by_projectile():
	_crash_plane()

func _process(delta):
	if self.linear_velocity.x < 0:
		sprite.scale.x = -1
		hitbox.scale.x = -1
	if self.linear_velocity.x > 0:
		sprite.scale.x = 1
		hitbox.scale.x = 1
	if(self.position.y > 1048):
		self.position.y = 1048
	if(self.position.y < 16):
		self.position.y = 16
	if(self.position.x < 0):
		self.linear_velocity = Vector2(rand_range(min_speed, max_speed), 0)
	if(self.position.x > 6000):
		self.linear_velocity =  Vector2(rand_range(min_speed, max_speed) * -1, 0)

func _on_Bomber_body_entered(body):
	if body.has_method("player_collision"):
		body.call("player_collision")
	if STATE == STATE_KILLED:
		_explode()
	else:
		_crash_plane()

func _crash_plane():
	$Explosion.play()
	STATE = STATE_KILLED
	self.gravity_scale = 1
	self.linear_damp = -1
	var fireParticles = preload("res://scenes/particles/fire_particles.tscn").instance()
	var smokeParticles = preload("res://scenes/particles/smoke_particles.tscn").instance()
	add_child(fireParticles)
	add_child(smokeParticles)

func _explode():
	$Explosion.play()
	emit_signal("minus_enemy_count", TYPE)
	var explosionParticles = preload("res://scenes/particles/explosion_particles.tscn").instance()	
	explosionParticles.position = self.global_position
	get_parent().add_child(explosionParticles)
	queue_free()

func _on_shotTimer_timeout():
	if STATE == STATE_LIVE:
		var shot = projectile.instance()
		shot.position = $Sprite/bombBay.global_position
		shot.linear_velocity = Vector2(self.linear_velocity.x, self.linear_velocity.y)
		shot.add_collision_exception_with(self)
		get_parent().add_child(shot)
	else:
		$shotTimer.stop()
