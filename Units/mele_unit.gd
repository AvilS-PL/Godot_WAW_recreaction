extends CharacterBody2D

@export var max_speed = randf() * 300
@export var acc = 8.0
@export var friction = 4.0

func _physics_process(delta):
	#var direction = Vector2.ZERO
	#if Input.is_action_pressed("ui_left"):
		#direction.x -= 1
	#if Input.is_action_pressed("ui_right"):
		#direction.x += 1
	#if Input.is_action_pressed("ui_up"):
		#direction.y -= 1
	#if Input.is_action_pressed("ui_down"):
		#direction.y += 1
	#direction = direction.normalized()
	#if direction != Vector2.ZERO:
		#velocity = velocity.move_toward(direction * max_speed, acc)
	#else:
		#velocity = velocity.move_toward(Vector2.ZERO, friction)
	
	#move_and_slide()
	move_and_collide(Vector2(max_speed,0) * delta)
	#move_and_collide(velocity.y * delta)
