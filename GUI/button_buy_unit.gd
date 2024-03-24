extends Control

signal hit
signal insufficient
signal many

var number = 0
var amount = 1.0

var cost = amount

func _ready():
	cost = amount
	var letter = ""
	if amount >= 1000:
		letter = "k"
		amount = floor(amount / 10) / 100
		if amount >= 1000:
			letter = "m"
			amount = floor(amount / 10) / 100
	$TopPanel/Label.text = str(amount) + letter + " $"
	await get_tree().create_timer(1.0).timeout

func button_show():
	$Animation.play("show")

func button_kill():
	$Button.disabled = true
	$Animation.play("kill")

func _on_button_pressed():
	if get_tree().current_scene.money < cost: 
		$Animation.stop()
		$Animation.play("insufficient")
		insufficient.emit()
	elif get_tree().current_scene.team_size >= 70 and $BottomPanel/Label.text != "BaseUpgrade":
		$Animation.stop()
		$Animation.play("insufficient")
		many.emit()
	else:
		$Animation.stop()
		$Animation.play("click")
		hit.emit(number, self)
