extends StaticBody2D

var team = "blue"
var max_health = 20.0
var health = max_health

func _ready():
	$HealthBar.max_value = health
	$HealthBar.value = health
	if team == "red":
		$HitBox.collision_layer = 2
		$HitBox.collision_mask = 1
	elif team == "blue":
		$HitBox.collision_layer = 1
		$HitBox.collision_mask = 2


func take_damage(taken):
	health -= taken
	$OtherAnimation.play("hit")
	if health <= 0:
		$HealthBar.change_health(health, 0.25)
		#Dodaj może animację burzenia
		queue_free()
	else:
		$HealthBar.change_health(health, 0.5)
