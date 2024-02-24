extends Control

var place = "startMenu"


func _on_button_red_pressed():
	get_tree().change_scene_to_file("res://game.tscn")
