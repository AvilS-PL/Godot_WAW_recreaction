extends ProgressBar


func change_health(health, time):
	var tween = create_tween()
	if health < 0:
		health = 0
	tween.tween_property(self, "value", health, time).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
