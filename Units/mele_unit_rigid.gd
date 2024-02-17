extends RigidBody2D

@export var speed = 100.0
var new_speed = speed
@export var max_health = 10
var health = max_health
@export var damage = 3
@export var cooldown = 1.0
var destinition = Vector2.ZERO
var team = "blue"

var enemies = []

func _ready():
	$HealthBar.max_value = health
	$HealthBar.value = health
	$Fight.wait_time = cooldown
	if team == "red":
		$Body.modulate = Color(0.8,0.2,0.2)
		$HitBox.collision_layer = 2
		#await get_tree().create_timer(5.0).timeout
		#queue_free()
	elif team == "blue":
		$Body.modulate = Color(0.0,0.6,0.9)
		$HitBox.collision_layer = 1

func _process(delta):
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
	if enemies.size() != 0:
		enemies[0].get_parent().take_damage(damage)
		$Fight.start()

func take_damage(taken):
	health -= taken
	if health <= 0:
		var time
		if health == 0:
			time = 0.5
		else:
			time = 0.5 * (1 - float(abs(health))/float(taken))
		$HealthBar.change_health(health, time)
		await get_tree().create_timer(time).timeout
		queue_free()
	else:
		$HealthBar.change_health(health, 0.5)
