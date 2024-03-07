extends Control

signal hit(what)
var number = 0
var amount = 1.0

func _ready():
	var letter = ""
	if amount >= 1000:
		letter = "k"
		amount = floor(amount / 10) / 100
		if amount >= 1000:
			letter = "m"
			amount = floor(amount / 10) / 100
	$TopPanel/Label.text = str(amount) + letter + " $"

func _on_button_pressed():
	hit.emit(number)
