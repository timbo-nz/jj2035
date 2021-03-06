extends RigidBody2D

export (PackedScene) var projectile

signal minus_enemy_count

export var min_speed = 300
export var max_speed = 450

onready var sprite = $Sprite
onready var hitbox = $Hitbox

var STATE_EXPLODED = "STATE_EXPLODED"
var STATE_KILLED = "STATE_KILLED"
var STATE_LIVE = "STATE_LIVE"

var STATE = STATE_LIVE

var TYPE = "JET"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var pitchScale = rand_range(0.85, 1.2)
	$Engine.set_pitch_scale(pitchScale)
	$Explosion.set_pitch_scale(rand_range(0.6, 0.8))
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
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

func hit_by_projectile():
	_crash_plane()

func _on_Enemy_Jet_body_entered(body):
	if body.has_method("player_collision"):
		body.call("player_collision")
	
	if STATE == STATE_KILLED:
		_explode()
	
	if STATE == STATE_EXPLODED:
		queue_free()

func _explode():
	STATE = STATE_EXPLODED
	sprite.visible = false
	remove_child($Hitbox)
	var explosionParticles = preload("res://scenes/particles/explosion_particles.tscn").instance()
	explosionParticles.position = self.global_position
	get_parent().add_child(explosionParticles)
	if !$Explosion.playing:
		$Explosion.play()

func _crash_plane():
	STATE = STATE_KILLED
	$Explosion.play()
	emit_signal("minus_enemy_count", TYPE)
	self.gravity_scale = 1
	self.linear_damp = -1
	var fireParticles = preload("res://scenes/particles/fire_particles.tscn").instance()
	var smokeParticles = preload("res://scenes/particles/smoke_particles.tscn").instance()
	add_child(fireParticles)
	add_child(smokeParticles)
	
func _shoot(target):
	var shot_velocity = (target.global_position - self.global_position).normalized() * 800
	$Firing.play()
	var shot = projectile.instance()
	shot.position = $Sprite/GunPos.global_position #use node for shoot position		
	shot.add_collision_exception_with(self) # don't want player to collide with bullet
	get_parent().add_child(shot) #don't want bullet to move with me, so add it as child of parent
	 

func _on_GunZone_body_entered(body):
	if (body.name == "Player"):
		_shoot(body)
