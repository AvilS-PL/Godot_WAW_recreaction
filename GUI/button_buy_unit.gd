extends Control

signal hit
signal insufficient

var number = 0
var amount = 1.0
var base = false

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
	$Button.disabled = false
	
func _on_button_pressed():
	if get_tree().current_scene.money < cost: 
		insufficient.emit()
		$Animation.stop()
		$Animation.play("insufficient")
	else:
		if base:
			$Button.disabled = true
		hit.emit(number, self)
		$Animation.stop()
		$Animation.play("click")
