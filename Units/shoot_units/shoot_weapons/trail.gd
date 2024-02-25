extends Line2D

var queue : Array
var max_length = 10

func _process(delta):
	
	$test.position = get_global_mouse_position()
	queue.push_front(get_global_mouse_position())
	
	if queue.size() > 5:
		queue.pop_back()
	
	clear_points()
	for point in queue:
		add_point(point)
