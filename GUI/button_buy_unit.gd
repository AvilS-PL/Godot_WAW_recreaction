extends Control

signal hit(what)
signal insufficient

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

func _on_button_pressed():
	if get_tree().current_scene.money < cost: 
		insufficient.emit()
		$Animation.stop()
		$Animation.play("insufficient")
	else:
		$Animation.stop()
		$Animation.play("click")
		hit.emit(number)
