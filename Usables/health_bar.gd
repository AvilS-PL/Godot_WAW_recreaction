extends ProgressBar

var sb = StyleBoxFlat.new()
var sb_back = StyleBoxFlat.new()
var colors = [
	Color("#ff2e00"),
	Color("#fe6b00"),
	Color("#fe9b00"),
	Color("#fed300"),
	Color("#feff00"),
	Color("#b5ff10"),
	Color("#7bff1d"),
	Color("#2cff45"),
]

func _ready():
	add_theme_stylebox_override("background", sb_back)
	add_theme_stylebox_override("fill", sb)
	sb.bg_color = colors[colors.size()-1]
	sb_back.bg_color = Color("#343434aa")
	sb.set_corner_radius_all(20)
	sb_back.set_corner_radius_all(20)
	#sb.set_border_width_all(4)
	#sb.border_color = Color("ececec")

func change_health(health, time):
	var tween = create_tween()
	var tween2 = create_tween()
	#sb.bg_color = Color(1 - ((health/max_value) * (health/max_value) * (health/ max_value)),0.1 + ((health/ max_value)),0.3 * health/max_value)
	if health < 0:
		health = 0
	var picked = colors[floor((health / max_value) * 8)]
	tween.tween_property(self, "value", health, time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween2.tween_property(sb, "bg_color", picked, time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
