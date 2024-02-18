extends RigidBody2D

#await get_tree().create_timer(5.0).timeout

var team = "blue"
var destinition = Vector2.ZERO

var animation_name = "punch"
var speed = 100.0
var max_health = 10.0
var damage = 5.0
var cooldown = 0.5

var new_speed = speed
var health = max_health

var enemies = []

func _ready():
	$AnimationPlayer.speed_scale = 1.05 / cooldown
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
			$Fight.start()
		new_speed = 0.0
		enemies.append(area)

func _on_hit_box_area_exited(area):
	if $HitBox.collision_layer != area.collision_layer:
		enemies.remove_at(enemies.find(area, 0))
		if enemies.size() == 0:
			new_speed = 100.0

func _on_fight_timeout():
	if enemies.size() != 0:
		$AnimationPlayer.play("punch")

func deal_damage():
	if enemies.size() != 0:
		enemies[0].get_parent().take_damage(damage, cooldown)
		$Fight.start()

func take_damage(taken, time):
	health -= taken
	
	if health <= 0:
		$HealthBar.change_health(health, time/4)
		#await get_tree().create_timer(cooldown / 12).timeout #to jeszcze do zdecydowania czy zostawić
		var deadEffect = load("res://Usables/blood_splash.tscn")
		var deadEffectI = deadEffect.instantiate()
		deadEffectI.global_position = global_position
		var world = get_tree().current_scene
		world.add_child(deadEffectI)
		
		queue_free()
	else:
		$HealthBar.change_health(health, time/2)