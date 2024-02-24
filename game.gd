extends Node2D

#var mele_unit = preload("res://Units/mele_units/mele_unit_8.tscn")
#var range_unit = preload("res://Units/range_units/range_unit_2.tscn")
var mode = true

var test = 0

func _process(delta):
	var era = "7"
	if mode: 
		if Input.is_action_just_pressed("mouse_left_click"):
			createShoot(era, "blue", get_global_mouse_position(), $MarkerEnemy.position)
		if Input.is_action_just_pressed("mouse_right_click"):
			createShoot(era, "red", get_global_mouse_position(), $MarkerBase.position)
	else:
		if Input.is_mouse_button_pressed(1):
			createShoot(era, "blue", get_global_mouse_position(), $MarkerEnemy.position)
		if Input.is_mouse_button_pressed(2):
			createShoot(era, "red", get_global_mouse_position(), $MarkerBase.position)
			
	if Input.is_action_just_pressed("ui_accept"):
		mode = !mode
		
	if test > 0:
		createMele(era, "red", $MarkerEnemy.position, $MarkerBase.position)
		test -= 1

func createShoot(era, team, posi, dest):
	var unitLoad = load("res://Units/shoot_units/shoot_unit_" + era + ".tscn")
	var unit = unitLoad.instantiate()
	unit.position = posi
	unit.destinition = dest
	unit.team = team
	#unit.cooldown = cool
	add_child(unit)

func createRange(era, team, posi, dest):
	var unitLoad = load("res://Units/range_units/range_unit_" + era + ".tscn")
	var unit = unitLoad.instantiate()
	unit.position = posi
	unit.destinition = dest
	unit.team = team
	unit.preBullet = load("res://Units/range_units/range_weapons/bullet_" + era + ".tscn")
	#unit.cooldown = cool
	add_child(unit)

func createMele(era, team, posi, dest):
	var unitLoad = load("res://Units/mele_units/mele_unit_" + era + ".tscn")
	var unit = unitLoad.instantiate()
	unit.position = posi
	unit.destinition = dest
	unit.team = team
	#unit.cooldown = cool
	add_child(unit)
