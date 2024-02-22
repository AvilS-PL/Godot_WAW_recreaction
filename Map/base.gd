extends StaticBody2D

@export var team = "blue"
var max_health = 50.0
var health = max_health

func _ready():
	$HealthBar.max_value = health
	$HealthBar.value = health
	if team == "red":
		$HitBox.collision_layer = 2
	elif team == "blue":
		$HitBox.collision_layer = 1


func take_damage(taken):
	health -= taken
	$OtherAnimation.play("hit")
	if health <= 0:
		$HealthBar.change_health(health, 0.25)
		#Dodaj może animację burzenia
		queue_free()
	else:
		$HealthBar.change_health(health, 0.5)
