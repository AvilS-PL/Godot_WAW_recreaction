extends Line2D

var queue : Array
var max_length = 10

var start_position = Vector2.ZERO
var destinition = Vector2.ZERO
var speed = 20.0
var damage = 3.0
var team = 1
var counter = 0

func _ready():
	$HitBox.position = start_position

func _process(delta):
	$HitBox.position = $HitBox.position.move_toward(destinition, speed)
	if $HitBox.position.x == destinition.x and $HitBox.position.y == destinition.y:
		visible = false
		await get_tree().create_timer(0.1).timeout
		queue_free()
	
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
		queue_free()
