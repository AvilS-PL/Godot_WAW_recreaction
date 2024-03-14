extends RigidBody2D

#await get_tree().create_timer(5.0).timeout
#!!! zamień wyszukiwanie przez searchboxa na wyszukiwanie tak jak tu odpowiedź:
#    https://forum.godotengine.org/t/how-to-get-closest-enemy-in-array/5051

var team = "blue"
var destinition = Vector2.ZERO

var def_speed = 80.0
var slow_down = 5.0
var max_health = 10.0
var damage = 3.0
var animation_speed = 1.0
var cooldown =  0.1
var weight = 60

var speed = def_speed
var new_speed = def_speed
var health = max_health

var new_destinition = null
var search_enemies = []
var found_enemy = null
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
		$HitBox.collision_mask = 1
		$SearchBox.collision_mask = 1
		collision_layer = 5
		collision_mask = 5
	elif team == "blue":
		add_to_group("team")
		$Side/Body.modulate = Color(0.0,0.6,0.9)
		$HitBox.collision_layer = 1
		$HitBox.collision_mask = 2
		$SearchBox.collision_mask = 2
		collision_layer = 3
		collision_mask = 3
	
	if destinition.x > position.x:
		$Side.scale.x = 1
	else:
		$Side.scale.x = -1

func _process(delta):
	speed = move_toward(speed, new_speed, slow_down)

func _integrate_forces(state):
	if new_destinition != null:
		if new_destinition.x > position.x:
			$Side.scale.x = 1
		else:
			$Side.scale.x = -1
		linear_velocity = (new_destinition - position).normalized() * speed
	else:
		if destinition.x > position.x:
			$Side.scale.x = 1
		else:
			$Side.scale.x = -1
		linear_velocity = (destinition - position).normalized() * speed

func _on_hit_box_area_entered(area):
	new_speed = 0.0
	mass = current_mass * 4
	enemies.append(area)
	if reloaded:
		$HandAnimation.play("punch")
		reloaded = false

func _on_hit_box_area_exited(area):
	enemies.remove_at(enemies.find(area, 0))
	if enemies.size() == 0:
		mass = current_mass
		new_speed = def_speed

func wait_time():
	$Fight.start()

func _on_fight_timeout():
	if enemies.size() != 0:
		$HandAnimation.play("punch")
	else:
		reloaded = true

func deal_damage():
	if enemies.size() != 0:
		var target = enemies[0]
		if enemies.size() != 1:
			for i in enemies:
				var d_i = position.distance_to(i.global_position)
				var d_t = position.distance_to(target.global_position)
				if  d_i < d_t:
					target = i
		target.get_parent().take_damage(damage)
	else:
		reloaded = true

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

func _on_search_box_area_entered(area):
	#if area.collision_mask != 128:
	search_enemies.append(area)
	if new_destinition == null:
		new_destinition = area.global_position
		found_enemy = area

func _on_search_box_area_exited(area):
	search_enemies.remove_at(search_enemies.find(area, 0))
	if search_enemies.size() == 0:
		new_destinition = null
		found_enemy = null
	elif area == found_enemy:
		found_enemy = search_enemies[0]
		new_destinition = search_enemies[0].global_position
		for i in search_enemies:
			var d_i = position.distance_to(i.global_position)
			if d_i < position.distance_to(new_destinition):
				new_destinition = i.global_position
				found_enemy = i


