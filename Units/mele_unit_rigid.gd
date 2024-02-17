extends RigidBody2D

@export var speed = 100.0
@export var health = 10
var new_speed = 100.0
var destinition = Vector2.ZERO
var team = "blue"

var enemies = []

func _ready():
	$HealthBar.max_value = health
	if team == "red":
		$Body.modulate = Color(0.8,0.2,0.2)
		$HitBox.collision_layer = 2
		#await get_tree().create_timer(5.0).timeout
		#queue_free()
	elif team == "blue":
		$Body.modulate = Color(0.0,0.6,0.9)
		$HitBox.collision_layer = 1


func _process(delta):
	if health < 1:
		queue_free()
	else:
		$HealthBar.value = health
	speed = move_toward(speed, new_speed, 5.0)
	linear_velocity = (destinition - position).normalized() * speed
	if destinition.x > position.x:
		$Body.flip_h = false
		$Head.flip_h = false
	else:
		$Body.flip_h = true
		$Head.flip_h = true


func _on_hit_box_area_entered(area):
	if $HitBox.collision_layer != area.collision_layer:
		if enemies.size() == 0:
			$Fight.start()
		new_speed = 0.0
		enemies.append(area)

func _on_hit_box_area_exited(area):
	if $HitBox.collision_layer != area.collision_layer:
		enemies.remove_at(enemies.find(area, 0))
		if enemies.size() == 0:
			new_speed = 100.0


func _on_fight_timeout():
	print("-1 ", team)
	if enemies.size() != 0:
		enemies[0].get_parent().health -= 3
		$Fight.start()
