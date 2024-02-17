extends ProgressBar

var sb = StyleBoxFlat.new()

func _ready():
	add_theme_stylebox_override("fill", sb)
	sb.bg_color = Color(0.1,0.9,0.0)

func change_health(health, time):
	var tween = create_tween()
	sb.bg_color = Color(1 - ((health/max_value) * (health/max_value) * (health/ max_value)),0.1 + ((health/ max_value)),0.0)
	if health < 0:
		health = 0
	tween.tween_property(self, "value", health, time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
