extends RigidBody2D

var destinition = Vector2.ZERO

func _ready():
	pass

func _process(delta):
	linear_velocity = (destinition - position).normalized() * 200
	if (destinition.x > position.x):
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true
