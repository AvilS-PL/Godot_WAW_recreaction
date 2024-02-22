extends RigidBody2D

#await get_tree().create_timer(5.0).timeout

var team = "blue"
var destinition = Vector2.ZERO

var speed = 100.0
var max_health = 10.0
var damage = 3.0
var cooldown =  1.0
var reloaddown = 1.0
#!!!może dodaj cooldown do animacji osobno?

var new_speed = speed
var health = max_health

var new_destinition = null
var search_enemies = []
var found_enemy = null
var current_mass = mass
var reloaded = true
var enemies = []
var preDeadEffect = load("res://Units/Usables/blood_splash.tscn")

func _ready():
	$HandAnimation.speed_scale = 1.0  / cooldown
	$Fight.wait_time = reloaddown + (0.45 * cooldown)
	$HealthBar.max_value = health
	$HealthBar.value = health
	if team == "red":
		$Side/Body.modulate = Color(0.8,0.2,0.2)
		$HitBox.collision_layer = 2
		$HitBox.collision_mask = 1
		$SearchBox.collision_mask = 1
	elif team == "blue":
		$Side/Body.modulate = Color(0.0,0.6,0.9)
		$HitBox.collision_layer = 1
		$HitBox.collision_mask = 2
		$SearchBox.collision_mask = 2
	if destinition.x > position.x:
		$Side.scale.x = 1
	else:
		$Side.scale.x = -1

func _process(delta):
	speed = move_toward(speed, new_speed, 5.0)
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
		#var des = clamp(destinition.x, -1, 1)
		#linear_velocity = (Vector2((300 - abs(position.y)) * des, -position.y)).normalized() * speed
	
func _on_hit_box_area_entered(area):
	#if $HitBox.collision_layer != area.collision_layer:
	new_speed = 0.0
	mass = current_mass * 4
	enemies.append(area)
	if reloaded:
		$HandAnimation.play("punch")
		#$Fight.start()
		reloaded = false

func _on_hit_box_area_exited(area):
	#if $HitBox.collision_layer != area.collision_layer:
	enemies.remove_at(enemies.find(area, 0))
	if enemies.size() == 0:
		mass = current_mass
		new_speed = 100.0

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
		reloaded = false
		$Fight.start()
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
