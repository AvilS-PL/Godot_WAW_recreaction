extends Line2D

var queue : Array
var max_length = 10

var start_position = Vector2.ZERO
var destinition = Vector2.ZERO
var speed = 20.0
var damage = 3.0
var team = 1
var counter = 0
var explosive = 0.0

func _ready():
	$HitBox.position = start_position

func _process(delta):
	$HitBox.position = $HitBox.position.move_toward(destinition, speed)
	if $HitBox.position.x == destinition.x and $HitBox.position.y == destinition.y:
		visible = false
		await get_tree().create_timer(0.1).timeout
		die()
	
	#---------------------
	
	queue.push_front($HitBox.position)
	
	if queue.size() > 5:
		queue.pop_back()
	
	clear_points()
	for point in queue:
		add_point(point)

func _on_hit_box_area_entered(area):
	if team != area.collision_layer and counter == 0:
		counter += 1
		area.get_parent().take_damage(damage)
		die()

func die():
	if explosive > 0:
		pass
		var preFireGunEffect = load("res://Units/Usables/explosion.tscn")
		var fireGunEffect = preFireGunEffect.instantiate()
		fireGunEffect.position = $HitBox.global_position
		fireGunEffect.scale = Vector2(explosive,explosive)
		#!!! dodaj żeby wybuch okaleczał jednestki do okoła
		if team == 1:
			var enemies = get_tree().get_nodes_in_group("enemies")
			for enemy in enemies:
				var distance = enemy.global_position.distance_to($HitBox.global_position)
				if distance < 100 * explosive:
					enemy.take_damage(damage * (1 - (distance*distance/(100 * explosive * 100 * explosive))))
		else:
			var enemies = get_tree().get_nodes_in_group("team")
			for enemy in enemies:
				var distance = enemy.global_position.distance_to($HitBox.global_position)
				if distance < 100 * explosive:
					enemy.take_damage(damage * (1 - distance/(100 * explosive)))
		var world = get_tree().current_scene
		world.add_child(fireGunEffect)
		queue_free()
	else:
		queue_free()
