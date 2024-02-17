extends RigidBody2D

@export var speed = 100
var destinition = Vector2.ZERO

func _ready():
	pass

func _process(delta):
	linear_velocity = (destinition - position).normalized() * speed
	if (destinition.x > position.x):
		$Body.flip_h = false
		$Head.flip_h = false
	else:
		$Body.flip_h = true
		$Head.flip_h = true
