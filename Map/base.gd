extends StaticBody2D

@export var team = "blue"
var max_health = 1000.0
var health = max_health
var test = "bruh"
var preDeadEffect = load("res://Map/base_explosion.tscn")

func _ready():
	$HealthBar.max_value = health
	$HealthBar.value = health
	if team == "red":
		$HitBox.collision_layer = 2
		$TeamBox.collision_layer = 2
		#$TeamBox.collision_mask = 2
	elif team == "blue":
		$HitBox.collision_layer = 1
		$TeamBox.collision_layer = 4
		#$TeamBox.collision_mask = 4


func take_damage(taken):
	health -= taken
	$OtherAnimation.play("hit")
	if health <= 0:
		$HealthBar.change_health(health, 0.25)
		
		var deadEffect = preDeadEffect.instantiate()
		deadEffect.global_position = $HitBox.global_position
		var world = get_tree().current_scene
		world.add_child(deadEffect)
		
		queue_free()
	else:
		$HealthBar.change_health(health, 0.5)
