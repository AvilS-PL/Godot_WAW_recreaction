extends RigidBody2D

#dodaj obrót do przeciwnika

var team = "blue"
var destinition = Vector2.ZERO
var new_destinition = null

var speed = 100.0
var max_health = 3.0
var damage = 5.0
var animation_speed = 1.0
var cooldown =  0.1

var new_speed = speed
var health = max_health

var current_mass = mass
var reloaded = true
var enemies = []
var preDeadEffect = load("res://Units/Usables/blood_splash.tscn")
var preBullet = load("res://Units/range_units/weapons/range_weapon_1.tscn")


func _ready():
	$HandAnimation.speed_scale = animation_speed
	$Fight.wait_time = cooldown
	$HealthBar.max_value = health
	$HealthBar.value = health
	if team == "red":
		$Side/Body.modulate = Color(0.8,0.2,0.2)
		$HitBox.collision_layer = 2
		$ShotBox.collision_mask = 1
		$Side.scale.x = -1
	elif team == "blue":
		$Side/Body.modulate = Color(0.0,0.6,0.9)
		$HitBox.collision_layer = 1
		$ShotBox.collision_mask = 2
		$Side.scale.x = 1

func _process(delta):
	speed = move_toward(speed, new_speed, 5.0)
	if new_destinition != null:
		if new_destinition.x > position.x:
			$Side.scale.x = 1
		else:
			$Side.scale.x = -1
	else:
		if destinition.x > position.x:
			$Side.scale.x = 1
		else:
			$Side.scale.x = -1
	linear_velocity = (destinition - position).normalized() * speed
	
	#var des = clamp(destinition.x, -1, 1)
	#linear_velocity = (Vector2((250 - abs(position.y)) * des, -position.y)).normalized() * speed

func _on_shot_box_area_entered(area):
	new_speed = 0.0
	mass = current_mass * 4
	enemies.append(area)
	if reloaded:
		$HandAnimation.play("punch")
		reloaded = false

func _on_shot_box_area_exited(area):
	enemies.remove_at(enemies.find(area, 0))
	if enemies.size() == 0:
		mass = current_mass
		new_speed = 100.0

func _on_fight_timeout():
	$HandAnimation.play("reload")

func prepere():
	if enemies.size() != 0:
		$HandAnimation.play("punch")
	else:
		reloaded = true

func throw():
	if enemies.size() != 0:
		$Side/Hand.visible = false
		$Fight.start()
		#!!! dodaj sprawdzanie czy w tego którego rzuca opłaca się wgl rzucać
		#var temp = null
		#var new_enemies = enemies
		#for i in range(enemies.size()):
			#if enemies[i].get_parent().health > 0:
				#temp = i
				#break
		var target = enemies[0]
		if enemies.size() != 1:
			for i in enemies:
				var d_i = position.distance_to(i.global_position)
				var d_t = position.distance_to(target.global_position)
				if  d_i < d_t:
					target = i
		
		var bullet = preBullet.instantiate()
		bullet.global_position = $Side/Hand.global_position
		bullet.rotation = $Side/Hand.rotation
		bullet.speed = 20
		bullet.damage = damage
		bullet.team = $HitBox.collision_layer
		bullet.scale.x = $Side.scale.x
		
		bullet.destinition = target.get_parent().global_position
		
		var world = get_tree().current_scene
		world.add_child(bullet)
	else:
		$HandAnimation.play("return")

func take_damage(taken):
	health -= taken
	$OtherAnimation.play("hit")
	if health <= 0:
		$HealthBar.change_health(health, 0.25)
		#!!! await get_tree().create_timer(cooldown / 12).timeout #to jeszcze do zdecydowania czy zostawić
		
		var deadEffect = preDeadEffect.instantiate()
		deadEffect.global_position = global_position
		var world = get_tree().current_scene
		world.add_child(deadEffect)
		
		queue_free()
	else:
		$HealthBar.change_health(health, 0.5)
