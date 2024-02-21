extends RigidBody2D

#może połączyć mele i rangera w jeden obiek i ustawiać im parametry? //cyba słaby pomysł...
#dodaj animacje rzutu i może dopiero zadaj damage jak trafi gościa?

var team = "blue"
var destinition = Vector2.ZERO

var speed = 100.0
var max_health = 3.0
var damage = 5.0
var cooldown = 2.0

var new_speed = speed
var health = max_health

var reloaded = true
var enemies = []
var last_enemy_position
var preDeadEffect = load("res://Units/Usables/blood_splash.tscn")
var preBullet = load("res://Units/Usables/range_rock.tscn")


func _ready():
	if cooldown < 1.0: 
		$HandAnimation.speed_scale = 1.0  / cooldown
		$Fight.wait_time = cooldown - (0.86 * cooldown)
	else:
		$Fight.wait_time = cooldown - 0.86
		$HandAnimation.speed_scale = 1.0
	$HealthBar.max_value = health
	$HealthBar.value = health
	if team == "red":
		$Side/Body.modulate = Color(0.8,0.2,0.2)
		$HitBox.collision_layer = 2
		$HitBox.collision_mask = 1
		$ShotBox.collision_mask = 1
		$Side.scale.x = -1
	elif team == "blue":
		$Side/Body.modulate = Color(0.0,0.6,0.9)
		$HitBox.collision_layer = 1
		$HitBox.collision_mask = 2
		$ShotBox.collision_mask = 2
		$Side.scale.x = 1

func _process(delta):
	speed = move_toward(speed, new_speed, 5.0)
	linear_velocity = (destinition - position).normalized() * speed

func _on_shot_box_area_entered(area):
	#if $HitBox.collision_layer != area.collision_layer:
	new_speed = 0.0
	enemies.append(area)
	if reloaded:
		last_enemy_position = area.get_parent().global_position
		$HandAnimation.play("punch")

func _on_shot_box_area_exited(area):
	#if $HitBox.collision_layer != area.collision_layer:
	enemies.remove_at(enemies.find(area, 0))
	if enemies.size() == 0:
		new_speed = 100.0

func _on_fight_timeout():
	$HandAnimation.play("reload")

func prepere():
	if enemies.size() != 0:
		last_enemy_position = enemies[0].get_parent().global_position
		$HandAnimation.play("punch")
	else:
		reloaded = true

func throw():
	reloaded = false
	$Fight.start()
	var temp = null
	for i in range(enemies.size()):
		if enemies[i].get_parent().health > 0:
			temp = i
			break
	
	var bullet = preBullet.instantiate()
	bullet.global_position = $Side/Hand.global_position
	bullet.rotation = $Side/Hand.rotation
	bullet.speed = 20
	bullet.damage = damage
	bullet.team = $HitBox.collision_layer
	bullet.scale.x = $Side.scale.x
	
	if temp == null:
		bullet.destinition = last_enemy_position
	else:
		bullet.destinition = enemies[temp].get_parent().global_position
	
	var world = get_tree().current_scene
	world.add_child(bullet)

func take_damage(taken):
	health -= taken
	$OtherAnimation.play("hit")
	if health <= 0:
		$HealthBar.change_health(health, 0.25)
		#await get_tree().create_timer(cooldown / 12).timeout #to jeszcze do zdecydowania czy zostawić
		
		var deadEffect = preDeadEffect.instantiate()
		deadEffect.global_position = global_position
		var world = get_tree().current_scene
		world.add_child(deadEffect)
		
		queue_free()
	else:
		$HealthBar.change_health(health, 0.5)
