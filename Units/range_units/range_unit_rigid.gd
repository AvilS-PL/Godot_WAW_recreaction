extends RigidBody2D

#może połączyć mele i rangera w jeden obiek i ustawiać im parametry? //cyba słaby pomysł...
#dodaj animacje rzutu i może dopiero zadaj damage jak trafi gościa?

var speed = 100.0
var new_speed = speed
var max_health = 10.0
var health = max_health
var damage = 3.0
var cooldown = 1.0
var destinition = Vector2.ZERO
var team = "blue"
var enemies = []

func _ready():
	$AnimationPlayer.speed_scale = 1.05 / cooldown
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
	#if destinition.x > position.x:
	if team == "blue":
		$Body.flip_h = false
		$Head.flip_h = false
		$Hand.flip_h = false
		$Hand.position.x = 40
	else:
		$Body.flip_h = true
		$Head.flip_h = true
		$Hand.flip_h = true
		$Hand.position.x = -40

func _on_shot_box_area_entered(area):
	if $HitBox.collision_layer != area.collision_layer:
		if enemies.size() == 0:
			$Fight.start()
		new_speed = 0.0
		enemies.append(area)

func _on_shot_box_area_exited(area):
	if $HitBox.collision_layer != area.collision_layer:
		enemies.remove_at(enemies.find(area, 0))
		if enemies.size() == 0:
			new_speed = 100.0

func _on_fight_timeout():
	if enemies.size() != 0:
		var temp = 0
		for i in range(enemies.size()):
			if enemies[i].get_parent().health > 0:
				temp = i
				break
		enemies[temp].get_parent().take_damage(damage, cooldown/2)
		#if team == "blue":
			#$AnimationPlayer.play("throw_right")
		#else:
			#$AnimationPlayer.play("throw_left")
		$Fight.start()

func take_damage(taken, time):
	health -= taken
	if health <= 0:
		$HealthBar.change_health(health, time/2)
		await get_tree().create_timer(time/4).timeout
		queue_free()
	else:
		$HealthBar.change_health(health, time)

