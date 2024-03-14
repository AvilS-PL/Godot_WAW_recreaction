extends StaticBody2D

signal destroyed(team)

@export var team = "blue"
var max_health = 100.0
var health = 100.0
var preDeadEffect = load("res://Map/base_explosion.tscn")
var start = false
var alive = true

func _ready():
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	if start:
		scale.y = 0
		tween.tween_property(self, "scale", Vector2(scale.x, 1), 1.0)
	else:
		$Side.scale.y = 0
		tween.tween_property($Side, "scale", Vector2(1, 1), 1.0)
	$HealthBar.max_value = max_health
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
	if alive:
		health -= taken
		$OtherAnimation.play("hit")
		if health <= 0:
			$HealthBar.change_health(health, 0.25)
			
			var deadEffect = preDeadEffect.instantiate()
			deadEffect.global_position = $HitBox.global_position
			deadEffect.scale = Vector2(1.5,1.5)
			var world = get_tree().current_scene
			world.add_child(deadEffect)
			
			$HitBox.collision_layer = 0
			$HealthBar.queue_free()
			
			destroyed.emit(team)
			
			var tween1 = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
			tween1.tween_property($Side, "scale", Vector2(1, 0.5), 0.5)
			tween1.tween_callback(queue_free)
		else:
			$HealthBar.change_health(health, 0.5)
