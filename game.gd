extends Node2D

var mele_unit = preload("res://Units/mele_units/mele_unit_0.tscn")
var range_unit = preload("res://Units/range_units/range_unit_1.tscn")
var mode = true

var test = 100

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
			createUnit(range_unit, "red", get_global_mouse_position(), $MarkerBase.position)
			
	if Input.is_action_just_pressed("ui_accept"):
		mode = !mode
		
	if test > 0:
		createUnit(mele_unit, "blue", $MarkerBase.position, $MarkerEnemy.position)
		createUnit(mele_unit, "red", $MarkerEnemy.position, $MarkerBase.position)
		test -= 1

func createUnit(type, team, posi, dest):
	var unit = type.instantiate()
	unit.position = posi
	unit.destinition = dest
	unit.team = team
	#unit.cooldown = cool
	add_child(unit)
