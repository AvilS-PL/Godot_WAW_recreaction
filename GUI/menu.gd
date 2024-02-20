extends Control

var place = "startMenu"

func _on_play_pressed():
	if place == "startMenu":
		place = "mainMenu"
		$PlayAnimation.play("play")

func _on_text_pressed():
	#tutaj wraz z tą animacją może się np tło zmieniać
	$StartMenu/TextAnimation.play("rotate")

func reset_text_xd():
	$StartMenu/Text.rotation = 0


func _on_back_pressed():
	if place == "mainMenu":
		place = "startMenu"
		$PlayAnimation.play("replay")
