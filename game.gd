extends Node2D

var mele_unit = preload("res://Units/mele_unit_rigid.tscn")
var range_unit = preload("res://Units/range_unit_rigid.tscn")
var mode = true

func _process(delta):
	if mode: 
		if Input.is_action_just_pressed("mouse_left_click"):
			createUnit(mele_unit, "blue", get_global_mouse_position(), $MarkerEnemy.position)
		if Input.is_action_just_pressed("mouse_right_click"):
			createUnit(range_unit, "red", get_global_mouse_position(), $MarkerBase.position)
	else:
		if Input.is_mouse_button_pressed(1):
			createUnit(mele_unit, "blue", get_global_mouse_position(), $MarkerEnemy.position)
		if Input.is_mouse_button_pressed(2):
			createUnit(mele_unit, "red", get_global_mouse_position(), $MarkerBase.position)
			
	if Input.is_action_just_pressed("ui_accept"):
		mode = !mode

func createUnit(type, team, posi, dest):
	var unit = type.instantiate()
	unit.position = posi
	unit.destinition = dest
	unit.team = team
	add_child(unit)
