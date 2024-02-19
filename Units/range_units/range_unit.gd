extends RigidBody2D

#może połączyć mele i rangera w jeden obiek i ustawiać im parametry? //cyba słaby pomysł...
#dodaj animacje rzutu i może dopiero zadaj damage jak trafi gościa?

var team = "blue"
var destinition = Vector2.ZERO

var speed = 100.0
var max_health = 20.0
var damage = 5.0
var cooldown = 1.0

var new_speed = speed
var health = max_health

var enemies = []
var last_enemy_position
var preDeadEffect = load("res://Usables/blood_splash.tscn")
var preBullet = load("res://Usables/bullet.tscn")


func _ready():
	if cooldown < 1.0: cooldown = 1.0
	$HealthBar.max_value = health
	$HealthBar.value = health
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

func _on_shot_box_area_entered(area):
	if $HitBox.collision_layer != area.collision_layer:
		if enemies.size() == 0:
			last_enemy_position = area.get_parent().global_position
			$HandAnimation.speed_scale = 1.0
			$HandAnimation.play("punch")
		new_speed = 0.0
		enemies.append(area)

func _on_shot_box_area_exited(area):
	if $HitBox.collision_layer != area.collision_layer:
		enemies.remove_at(enemies.find(area, 0))
		if enemies.size() == 0:
			new_speed = 100.0

func prepere():
	if enemies.size() != 0:
		last_enemy_position = enemies[0].get_parent().global_position
		$HandAnimation.speed_scale = 1.0
		$HandAnimation.play("punch")

func throw():
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

func reload():
	$HandAnimation.speed_scale = 1.0 / cooldown
	$HandAnimation.play("reload")
	
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
