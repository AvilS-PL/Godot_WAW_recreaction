extends Control

signal hit(what)
var number = 0

func _on_button_pressed():
	hit.emit(number)
