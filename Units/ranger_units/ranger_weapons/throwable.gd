extends Area2D

var destinition = Vector2.ZERO
var speed = 20.0
var damage = 3.0
var team = 1
var counter = 0
var roter = 0.0

func _process(delta):
	position = position.move_toward(destinition, speed)
	if roter != 0:
		rotation += roter / 100
	if position.x == destinition.x and position.y == destinition.y:
		$Sprite2D.visible = false
		await get_tree().create_timer(0.1).timeout
		queue_free()


func _on_area_entered(area):
	if team != area.collision_layer and counter == 0:
		counter += 1
		area.get_parent().take_damage(damage)
		queue_free()
