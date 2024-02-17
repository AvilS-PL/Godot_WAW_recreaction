extends Node2D

var mele_unit = preload("res://Units/mele_unit_rigid.tscn")

func _process(delta):
	if Input.is_action_just_pressed("mouse_left_click"):
		createUnit(mele_unit, "blue", get_global_mouse_position(), $MarkerEnemy.position)

	if Input.is_action_just_pressed("mouse_right_click"):
		createUnit(mele_unit, "red", get_global_mouse_position(), $MarkerBase.position)


func createUnit(type, team, posi, dest):
	var unit = type.instantiate()
	unit.position = posi
	unit.destinition = dest
	add_child(unit)
