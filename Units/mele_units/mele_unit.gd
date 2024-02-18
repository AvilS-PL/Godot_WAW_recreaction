extends RigidBody2D

#await get_tree().create_timer(5.0).timeout

var team = "blue"
var destinition = Vector2.ZERO

var speed = 100.0
var max_health = 10.0
var damage = 3.0
var cooldown = 1.0

var new_speed = speed
var health = max_health

var enemies = []
var preDeadEffect = load("res://Usables/blood_splash.tscn")

func _ready():
	if cooldown < 1: cooldown = 1
	$HandAnimation.speed_scale = 1
	$HealthBar.max_value = health
	$HealthBar.value = health
	$Fight.wait_time = cooldown
	if team == "red":
		$Side/Body.modulate = Color(0.8,0.2,0.2)
		$HitBox.collision_layer = 2
		$Side.scale.x = -1
	elif team == "blue":
		$Side/Body.modulate = Color(0.0,0.6,0.9)
		$HitBox.collision_layer = 1
		$Side.scale.x = 1

func _process(delta):
	speed = move_toward(speed, new_speed, 5.0)
	linear_velocity = (destinition - position).normalized() * speed

func _on_hit_box_area_entered(area):
	if $HitBox.collision_layer != area.collision_layer:
		if enemies.size() == 0:
			$HandAnimation.play("punch")
		new_speed = 0.0
		enemies.append(area)

func _on_hit_box_area_exited(area):
	if $HitBox.collision_layer != area.collision_layer:
		enemies.remove_at(enemies.find(area, 0))
		if enemies.size() == 0:
			new_speed = 100.0

func _on_fight_timeout():
	if enemies.size() != 0:
		$HandAnimation.play("punch")

func deal_damage():
	if enemies.size() != 0:
		enemies[0].get_parent().take_damage(damage)
		$Fight.start()

func take_damage(taken):
	health -= taken
	$OtherAnimation.play("hit")
	if health <= 0:
		$HealthBar.change_health(health, 0.25)
		
		var deadEffect = preDeadEffect.instantiate()
		deadEffect.global_position = global_position
		var world = get_tree().current_scene
		world.add_child(deadEffect)
		
		queue_free()
	else:
		$HealthBar.change_health(health, 0.5)
