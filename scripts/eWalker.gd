extends KinematicBody2D

export (PackedScene) var projectile
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2()
var jumping = false
var newAnim = false


var playerInRange = false

onready var sprite = $Anim
onready var shotPos = $shoot

func _ready():	
	sprite.play("idle")

func _physics_process(delta):
	var playerPos = get_parent().get_node("Player").global_position
	
	if playerPos.x > self.position.x && is_on_floor():
		sprite.scale.x = -1
	elif playerPos.x < self.position.x && is_on_floor():
		sprite.scale.x = 1
	
	velocity.y += 2 #gravity?	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor():
		sprite.play("idle")
	
	if playerInRange && is_on_floor():
		jump()
	
	# shoot at apex of jump
	if !is_on_floor() && velocity.y < 1 && velocity.y > -1:
		shoot(playerPos)
		


func jump():
	sprite.play("jump")
	# figure out how to jump to player height
	# within reason, of course
	velocity.y = rand_range(-150, -250)
	$JumpSound.play()
	
func shoot(target):
	var shot = projectile.instance()
	shot.position = shotPos.global_position #use node for shoot position
	
	var shot_velocity = -(self.global_position - target).normalized() * 500
	
	shot.linear_velocity = shot_velocity
	shot.add_collision_exception_with(self) # don't want player to collide with bullet
	get_parent().add_child(shot) #don't want bullet to move with me, so add it as child of parent
	sprite.play("shoot")
	
	var pitchScale = rand_range(0.8, 1.2)
	print(pitchScale)
	$ShootSound.set_pitch_scale(pitchScale)
	
	$ShootSound.play()
	
	var explosionParticles = preload("res://scenes/particles/explosion_particles.tscn").instance()
	explosionParticles.scale = Vector2(0.2, 0.2)
	explosionParticles.position = shotPos.global_position
	get_parent().add_child(explosionParticles)


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		playerInRange = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		playerInRange = false
