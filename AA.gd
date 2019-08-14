extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var TYPE = "AA"
signal minus_enemy_count

export (int) var HP

onready var gunSprite = $gunSprite
onready var gunRotation = $bodySprite/gunRotation

onready var gun1Pos = $gunSprite/gun1Pos
onready var gun2Pos = $gunSprite/gun2Pos

var shoot_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	HP = rand_range(1, 2)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var playerPos = get_parent().get_node("Player").global_position

	if gunSprite.global_position.distance_to(playerPos) < 500:
		shoot_time += 10
		gunSprite.look_at(playerPos)
		gunSprite.rotation_degrees += 90
		if shoot_time > 500:
			_shoot(playerPos)

func hit_by_projectile():
	if HP > 0:
		HP -= 1
	else:
		_explode()
		
func _explode():
	emit_signal("minus_enemy_count", TYPE)
	var explosionParticles = preload("res://explosion_particles.tscn").instance()
	explosionParticles.position = self.global_position
	get_parent().add_child(explosionParticles)
	queue_free()

func _shoot(target):	
	var p1 = preload("res://pTracer.tscn").instance()
	p1.position = gun1Pos.global_position
	
	var p2 = preload("res://pTracer.tscn").instance()
	p2.position = gun2Pos.global_position
	
	var shot_velocity = -(self.global_position - target).normalized() * 500
	
	p1.linear_velocity = shot_velocity
	p2.linear_velocity = shot_velocity
	
	p1.gravity_scale = 0
	p2.gravity_scale = 0
	
	get_parent().add_child(p1)
	get_parent().add_child(p2)
	
	shoot_time = 0
	pass