extends RigidBody2D

#!!!dodaj amunicję ale dopiero po zrobieniu gameplay-u

var team = "blue"
var destinition = Vector2.ZERO
var new_destinition = null

var def_speed = 80.0
var slow_down = 5.0
var max_health = 10.0
var damage = 5.0
var animation_speed = 1.0
var cooldown = 0.5
var rotation_speed = 5.0
var bullet_speed = 30
var bullet_size = 5
#var ammo = 3

var new_rotation = 0
var speed = def_speed
var new_speed = def_speed
var health = max_health

var current_mass = mass
var current_enemy = null
var reloaded = false
var enemies = []
var preDeadEffect = load("res://Units/Usables/blood_splash.tscn")
var preFireGunEffect = load("res://Units/Usables/fire_gun.tscn")
var preTrail = load("res://Units/shoot_units/shoot_weapons/trail.tscn")

func _ready():
	$HandAnimation.speed_scale = animation_speed
	$Reload.wait_time = cooldown
	$HealthBar.max_value = health
	$HealthBar.value = health
	if team == "red":
		$Side/Body.modulate = Color(0.8,0.2,0.2)
		$HitBox.collision_layer = 2
		$ShotBox.collision_mask = 1
		$Side.scale.x = -1
		collision_layer = 5
		collision_mask = 5
	elif team == "blue":
		$Side/Body.modulate = Color(0.0,0.6,0.9)
		$HitBox.collision_layer = 1
		$ShotBox.collision_mask = 2
		$Side.scale.x = 1
		collision_layer = 3
		collision_mask = 3

func _process(delta):
	speed = move_toward(speed, new_speed, slow_down)
	$Side/Hand.rotation = move_toward($Side/Hand.rotation, new_rotation, rotation_speed / 100)
	
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
			
	if current_enemy != null:
		if round($Side/Hand.rotation * 1000) == round(new_rotation * 1000):
			if reloaded:
				shoot()
			elif $Reload.time_left == 0:
				$Reload.start()

func _integrate_forces(state):
	linear_velocity = (destinition - position).normalized() * speed

func _on_reload_timeout():
	if enemies.size() != 0:
		reloaded = true

func _on_shot_box_area_entered(area):
	new_speed = 0.0
	mass = current_mass * 4
	if enemies.size() == 0:
		reloaded = false
	enemies.append(area)
	find_closest()

func _on_shot_box_area_exited(area):
	enemies.remove_at(enemies.find(area, 0))
	if enemies.size() == 0:
		mass = current_mass
		new_speed = def_speed
		new_rotation = 0
		current_enemy = null
		new_destinition = null
		reloaded = false
	elif area == current_enemy:
		find_closest()

func find_closest():
	new_rotation = 0
	new_destinition = null
	current_enemy = null
	if enemies.size() != 0:
		var target = enemies[0]
		if enemies.size() != 1:
			for i in enemies:
				var d_i = position.distance_to(i.global_position)
				var d_t = position.distance_to(target.global_position)
				if  d_i < d_t:
					target = i
		current_enemy = target
		new_destinition = target.global_position
		new_rotation = atan2(current_enemy.global_position.y - position.y,
		current_enemy.global_position.x - position.x)
		if new_rotation > PI/2:
			new_rotation = PI - new_rotation
		elif new_rotation < -PI/2:
			new_rotation = -PI - new_rotation

func shoot():
	reloaded = false
	
	#!!! zdecyduj się czy zostawić firegunEffect
	var fireGunEffect = preFireGunEffect.instantiate()
	fireGunEffect.position.x += $Side/Hand.texture.get_width() * 0.6
	fireGunEffect.position.y -= $Side/Hand.texture.get_height() * 0.3
	$Side/Hand.add_child(fireGunEffect)
	
	var trail = preTrail.instantiate()
	trail.start_position = $Side/Hand.global_position
	trail.speed = bullet_speed
	trail.damage = damage
	trail.team = $HitBox.collision_layer
	trail.width = bullet_size
	
	trail.destinition = current_enemy.global_position
	
	var world = get_tree().current_scene
	world.add_child(trail)

	$HandAnimation.play("shoot")

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
