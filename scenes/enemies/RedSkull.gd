extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var gunPos = $Mouth
onready var sprite = $Sprite

var TYPE = "RED_SKULL"
signal minus_enemy_count
# Called when the node enters the scene tree for the first time.

var STATE

var STATE_ALIVE = "STATE_ALIVE"
var STATE_DEAD = "STATE_DEAD"

var ALERTED = false

var dying = false

var anim = ""

var shoot_time = 0
export (int) var SPEED
export (int) var HP

func _ready():
	STATE = STATE_ALIVE
	$Movement.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var playerPos = get_parent().get_node("Player").global_position
	
	var new_anim = "idle"
	
	if self.global_position.distance_to(playerPos) < 800:
		ALERTED = true
	
	if STATE == STATE_ALIVE && !ALERTED:
		var motion = Vector2(-1, 0) * SPEED * delta
		position += motion
	
	if STATE == STATE_ALIVE && ALERTED:
		var direction = (playerPos - position).normalized()
		
		if self.global_position.distance_to(playerPos) > 300:
			var motion = direction * SPEED * delta
			position += motion
		
		if gunPos.global_position.distance_to(playerPos) < 500:
			shoot_time += 10
			if shoot_time > 400:
				_shoot(playerPos)
				new_anim = "shoot"

	if STATE == STATE_DEAD:
		new_anim = "dead"
		_die()
		var direction = Vector2(0, 1).normalized()
		var motion = direction * SPEED * delta
		position += motion
		
	if new_anim != anim:
		anim = new_anim
		sprite.play(anim)
	
func _die():
	sprite.play("dead")
	if !dying:
		var explosionParticles = preload("res://scenes/particles/explosion_particles.tscn").instance()
		explosionParticles.position = self.global_position
		get_parent().add_child(explosionParticles)
		dying = true

func hit_by_projectile():
	HP -= 1
	if HP == 0:
		remove_child($Hitbox)
		STATE = STATE_DEAD
		emit_signal("minus_enemy_count", TYPE)

func _shoot(target):	
	$Shoot.set_pitch_scale(rand_range(0.8, 1.2))
	$Shoot.play()
	var p1 = preload("res://scenes/projectiles/pTracer.tscn").instance()
	p1.position = gunPos.global_position
	var shot_velocity = -(self.global_position - target).normalized() * 500
	p1.linear_velocity = shot_velocity
	p1.gravity_scale = 0
	p1.add_collision_exception_with(self)
	get_parent().add_child(p1)
	shoot_time = 0