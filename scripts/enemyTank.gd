extends KinematicBody2D
signal minus_enemy_count



var LEFT = -1
var RIGHT = 1

var TYPE = "TANK"

var DIRECTION = RIGHT

var speed

export (PackedScene) var projectile

onready var sprite = $AnimatedSprite

const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
var linear_vel = Vector2()
export var min_speed = 50
export var max_speed = 100

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = rand_range(min_speed, max_speed)
	
func hit_by_projectile():	
	print("take damage")
	var explosionParticles = preload("res://scenes/explosion_particles.tscn").instance()	
	explosionParticles.position = self.global_position
	get_parent().add_child(explosionParticles)
	emit_signal("minus_enemy_count", TYPE)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	linear_vel += delta * GRAVITY_VEC
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL)	
	if(self.position.x < 0):
		DIRECTION = RIGHT
	if(self.position.x > 6000):
		DIRECTION = LEFT
		
	sprite.scale.x = 2 *DIRECTION
	linear_vel.x = speed * DIRECTION		

func _on_shotTimer_timeout():
		var shot = projectile.instance()
		shot.position = sprite.global_position #use node for shoot position		
		shot.linear_velocity = Vector2(linear_vel.x + 200 * sprite.scale.x, -150)
		shot.add_collision_exception_with(self) # don't want player to collide with bullet
		get_parent().add_child(shot) #don't want bullet to move with me, so add it as child of parent
	
