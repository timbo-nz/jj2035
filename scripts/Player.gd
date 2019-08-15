extends KinematicBody2D

signal update_hud_score
signal update_hud_mission_status_text

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var vSpeed = 50
export (int) var hSpeed = 200

export (PackedScene) var projectile

onready var sprite = $Sprite
onready var hitbox = $Hitbox

var STATE_LIVE = "STATE_LIVE"
var STATE_KILLED = "STATE_KILLED"

var STATE = STATE_LIVE

var vThrottle = 0
var hThrottle = 0

export (int) var vMax = 4
export (int) var hMax = 3

var velocity = Vector2()

var flipCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	STATE = STATE_LIVE
	pass # Replace with function body.

func get_input():
	if STATE == STATE_LIVE:
		if Input.is_action_just_pressed("shoot"):        
			var missile = projectile.instance()
			missile.position = $Sprite/missilePoint.global_position #use node for shoot position
			missile.scale.x = sprite.scale.x
			missile.rotation = sprite.rotation
			missile.linear_velocity = Vector2(self.velocity.x + 200 * sprite.scale.x, self.velocity.y)
			missile.add_collision_exception_with(self) # don't want player to collide with bullet
			get_parent().add_child(missile) #don't want bullet to move with me, so add it as child of parent
	
		if Input.is_action_just_pressed('right'):
			if hThrottle < hMax:            
				hThrottle += 1
		if Input.is_action_just_pressed('left'):
			if hThrottle > hMax * -1:
				hThrottle -= 1
		if Input.is_action_just_pressed('down'):
			if vThrottle < vMax:
				vThrottle += 1
		if Input.is_action_just_pressed('up'):
			if vThrottle > vMax * -1:
				vThrottle -= 1
		velocity.x = hThrottle * hSpeed
		velocity.y = vThrottle * vSpeed

func transform_sprite():
	if velocity.x < 0:
		sprite.scale.x = -1
		hitbox.scale.x = -1
		
	if velocity.x > 0:
		sprite.scale.x = 1
		hitbox.scale.x = 1
		
	if position.y <= 0:
		vThrottle = 0
		
	sprite.rotation = deg2rad(vThrottle * 5 * sprite.scale.x)
	hitbox.rotation = deg2rad(vThrottle * 5 * sprite.scale.x)

func player_collision():
	STATE = STATE_KILLED

func _physics_process(delta):
	get_input()
	transform_sprite()	
	
	flipCount += 100
	
	if STATE == STATE_KILLED && !is_on_floor():
		if	flipCount > 1000:
			sprite.scale.y *= -1
			flipCount = 0
		velocity.y += 9.8
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if STATE == STATE_KILLED:
		if $deathTimer.is_stopped():
			$deathTimer.start()
		var explosionParticles = preload("res://scenes/particles/explosion_particles.tscn").instance()
		explosionParticles.position = self.global_position
		get_parent().add_child(explosionParticles)

func hit_by_projectile():
	STATE = STATE_KILLED

func _on_deathTimer_timeout():
	queue_free()
	get_tree().reload_current_scene()

func _on_update_score():
	emit_signal("update_hud_score")

func _on_update_mission_status_text(objectivesLeft):
	emit_signal("update_hud_mission_status_text", objectivesLeft)
