extends Area2D

var destinition = Vector2.ZERO
var speed = 20.0
var damage = 3.0
var team = 1

func _ready():
	pass 

func _process(delta):
	#position.x = move_toward(position.x, destinition.x, speed)
	#position.y = move_toward(position.y, destinition.y, speed)
	position = position.move_toward(destinition, speed)
	if position.x == destinition.x and position.y == destinition.y:
		queue_free()


func _on_area_entered(area):
	if team != area.collision_layer:
		area.get_parent().take_damage(damage)
		queue_free()
