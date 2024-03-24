extends RigidBody2D

#!!!???dodaj rotating taki jak w shoot ale dopiero po zrobieniu gameplay-u

var team = "blue"
var destinition = Vector2.ZERO
var game = true
var price = 10.0

var def_speed = 80.0
var slow_down = 5.0
var max_health = 3.0
var damage = 5.0
var animation_speed = 1.0
var cooldown = 0.1
var bullet_speed = 20.0
var bullet_rotation = 0.0
var preBullet = load("res://Units/ranger_units/ranger_weapons/bullet_1.tscn")
var weight = 60
var range = 200
var thrower = true

var speed = def_speed
var new_speed = def_speed
var health = max_health

var target = null
var reloaded = true

var current_mass = mass
var enemies = []
var preDeadEffect = load("res://Units/Usables/blood_splash.tscn")

func _ready():
	speed = def_speed
	new_speed = def_speed
	health = max_health

	$HandAnimation.speed_scale = animation_speed
	$Reload.wait_time = cooldown
	$HealthBar.max_value = health
	$HealthBar.value = health
	if team == "red":
		add_to_group("enemies")
		$Side/Body.modulate = Color(0.8,0.2,0.2)
		$HitBox.collision_layer = 2
		$Side.scale.x = -1
		collision_layer = 5
		collision_mask = 5
	elif team == "blue":
		add_to_group("team")
		$Side/Body.modulate = Color(0.0,0.6,0.9)
		$HitBox.collision_layer = 1
		$Side.scale.x = 1
		collision_layer = 3
		collision_mask = 3

func _process(delta):
	speed = move_toward(speed, new_speed, slow_down)
	if target != null:
		if target.global_position.x > position.x:
			$Side.scale.x = 1
		else:
			$Side.scale.x = -1
	else:
		if destinition.x > position.x:
			$Side.scale.x = 1
		else:
			$Side.scale.x = -1

func _integrate_forces(state):
	if speed != 0:
		linear_damp = 0
		linear_velocity = (destinition - position).normalized() * speed
	else:
		#!!! do ulepszenia ten system
		linear_velocity.x = 0
		linear_damp = current_mass/10

func search_enemy():
	if team == "blue":
		var search_enemies = get_tree().get_nodes_in_group("enemies")
		for i in get_tree().get_nodes_in_group("bases"):
			if i.name == "Base2":
				search_enemies.append(i)
		if target == null or !search_enemies.has(target):
			search_closest_enemy(search_enemies)
	elif team == "red":
		var search_enemies = get_tree().get_nodes_in_group("team")
		for i in get_tree().get_nodes_in_group("bases"):
			if i.name == "Base1":
				search_enemies.append(i)
		if target == null or !search_enemies.has(target):
			search_closest_enemy(search_enemies)
	if target != null:
		new_speed = 0.0
		mass = current_mass * 4
		try_throw()
	else:
		mass = current_mass
		new_speed = def_speed

func search_closest_enemy(search_enemies):
	target = null
	for i in search_enemies:
		var d_i = global_position.distance_to(i.global_position)
		if d_i < range:
			if target == null:
				target = i
			elif d_i < position.distance_to(target.global_position):
				target = i

func try_throw():
	if reloaded:
		$HandAnimation.play("punch")

func check_throw():
	if target != null:
		throw(target.global_position)
	else:
		reloaded = false
		$HandAnimation.play("return")

func _on_timer_timeout():
	search_enemy()

func _on_fight_timeout():
	if thrower:
		$HandAnimation.play("reload")
	else:
		reloaded = true

func start_reload():
	$Reload.start()

func reload():
	reloaded = true

func throw(des):
	if thrower:
		$Side/Hand.visible = false
		$Reload.start()
	else:
		$HandAnimation.play("reload")
	reloaded = false
	var angle = atan2(des.y - position.y, des.x - position.x)
	
	var bullet = preBullet.instantiate()
	bullet.global_position = $Side/Hand.global_position
	bullet.speed = bullet_speed
	bullet.damage = damage
	bullet.rotation = angle
	bullet.roter = bullet_rotation
	bullet.team = $HitBox.collision_layer
	
	bullet.destinition = des
	
	var world = get_tree().current_scene
	world.add_child(bullet)

func take_damage(taken):
	health -= taken
	$OtherAnimation.play("hit")
	if health <= 0:
		$HealthBar.change_health(health, 0.25)
		
		var deadEffect = preDeadEffect.instantiate()
		deadEffect.global_position = global_position
		var world = get_tree().current_scene
		world.add_child(deadEffect)
		
		get_parent().add_money(price, team)
		queue_free()
	else:
		$HealthBar.change_health(health, 0.5)
