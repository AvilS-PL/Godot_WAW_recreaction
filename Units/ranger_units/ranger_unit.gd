extends RigidBody2D

#!!!no to tak, pomysł na duży update:
# zmiana kolejności działań na bardziej rzeczywiste
# 1) napotkanie przeciwnika -> dodanie do kolejki i rozpoczęcie celowania
# 2) jeżeli dany przeciwnik wciąż istnieje to do niego strzel
# 	 a jeżeli nie to od nowa rozpocznij celowanie w następnego typa
# 3) po strzale przeładowanie
#!!!???dodaj rotating taki jak w shoot ale dopiero po zrobieniu gameplay-u

var team = "blue"
var destinition = Vector2.ZERO
var game = true

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

var speed = def_speed
var new_speed = def_speed
var health = max_health

var new_destinition = null
var current_mass = mass
var reloaded = true
var enemies = []
var preDeadEffect = load("res://Units/Usables/blood_splash.tscn")

func _ready():
	speed = def_speed
	new_speed = def_speed
	health = max_health

	$HandAnimation.speed_scale = animation_speed
	$Fight.wait_time = cooldown
	$HealthBar.max_value = health
	$HealthBar.value = health
	if team == "red":
		add_to_group("enemies")
		$Side/Body.modulate = Color(0.8,0.2,0.2)
		$HitBox.collision_layer = 2
		$ShotBox.collision_mask = 1
		$Side.scale.x = -1
		collision_layer = 5
		collision_mask = 5
	elif team == "blue":
		add_to_group("team")
		$Side/Body.modulate = Color(0.0,0.6,0.9)
		$HitBox.collision_layer = 1
		$ShotBox.collision_mask = 2
		$Side.scale.x = 1
		collision_layer = 3
		collision_mask = 3

func _process(delta):
	speed = move_toward(speed, new_speed, slow_down)
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

func _integrate_forces(state):
	linear_velocity = (destinition - position).normalized() * speed

func _on_shot_box_area_entered(area):
	new_speed = 0.0
	mass = current_mass * 4
	enemies.append(area)
	if reloaded:
		prepere()

func _on_shot_box_area_exited(area):
	enemies.remove_at(enemies.find(area, 0))
	if enemies.size() == 0:
		new_destinition = null
		mass = current_mass
		new_speed = def_speed

func _on_fight_timeout():
	$HandAnimation.play("reload")

func prepere():
	if enemies.size() != 0:
		reloaded = false
		$HandAnimation.play("punch")
		var target = enemies[0]
		if enemies.size() != 1:
			for i in enemies:
				var d_i = position.distance_to(i.global_position)
				var d_t = position.distance_to(target.global_position)
				if  d_i < d_t:
					target = i
		new_destinition = target.global_position
	else:
		reloaded = true

func action1():
	if enemies.size() != 0:
		$Side/Hand.visible = false
		$Fight.start()
		throw()
	else:
		$HandAnimation.play("return")

func action2():
	if enemies.size() != 0:
		$HandAnimation.play("reload")
		throw()
		await get_tree().create_timer(cooldown + 0.4).timeout
		prepere()
	else:
		$HandAnimation.play("return")

func throw():
	var target = enemies[0]
	if enemies.size() != 1:
		for i in enemies:
			var d_i = position.distance_to(i.global_position)
			var d_t = position.distance_to(target.global_position)
			if  d_i < d_t:
				target = i
	new_destinition = target.global_position
	var angle = atan2(new_destinition.y - position.y, new_destinition.x - position.x)
	
	var bullet = preBullet.instantiate()
	bullet.global_position = $Side/Hand.global_position
	bullet.speed = bullet_speed
	bullet.damage = damage
	bullet.rotation = angle
	bullet.roter = bullet_rotation
	bullet.team = $HitBox.collision_layer
	
	bullet.destinition = target.get_parent().global_position
	
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
		
		queue_free()
	else:
		$HealthBar.change_health(health, 0.5)
