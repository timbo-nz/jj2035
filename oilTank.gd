extends StaticBody2D

signal minus_enemy_count

onready var sprite = $Sprite
onready var deadSprite = $deadSprite

var TYPE = "OIL_TANK"
var HP

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():	
	deadSprite.visible = false
	HP = rand_range(2,4)

func hit_by_projectile():
	if HP > 1:
		HP -= 1
	else:
		_explode()

func _explode():
	print("oil tank exploding")
	emit_signal("minus_enemy_count", TYPE)
	var explosionParticles = preload("res://explosion_particles.tscn").instance()
	explosionParticles.position = self.global_position
	get_parent().add_child(explosionParticles)
	sprite.visible = false
	deadSprite.visible = true
	remove_child($CollisionPolygon2D)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
