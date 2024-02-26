extends Node2D

#var mele_unit = preload("res://Units/mele_units/mele_unit_8.tscn")
#var range_unit = preload("res://Units/range_units/range_unit_2.tscn")

var test = 0

var mode = true
var select = "5"
var type = 2

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		$UI/SpinBox.value += 1
	if Input.is_action_just_pressed("ui_down"):
		$UI/SpinBox.value -= 1
	if Input.is_action_just_pressed("ui_left"):
		$UI/SpinBox2.value -= 1
	if Input.is_action_just_pressed("ui_right"):
		$UI/SpinBox2.value += 1
	if mode: 
		if Input.is_action_just_pressed("mouse_left_click"):
			if type == 0:
				createMele(select, "blue", get_global_mouse_position(), $MarkerEnemy.position)
			elif type == 1:
				createRange(select, "blue", get_global_mouse_position(), $MarkerEnemy.position)
			elif type == 2:
				createShoot(select, "blue", get_global_mouse_position(), $MarkerEnemy.position)
			elif type == 3:
				createSpecial(select, "blue", get_global_mouse_position(), $MarkerEnemy.position)
		if Input.is_action_just_pressed("mouse_right_click"):
			if type == 0:
				createMele(select, "red", get_global_mouse_position(), $MarkerBase.position)
			elif type == 1:
				createRange(select, "red", get_global_mouse_position(), $MarkerBase.position)
			elif type == 2:
				createShoot(select, "red", get_global_mouse_position(), $MarkerBase.position)
			elif type == 3:
				createSpecial(select, "red", get_global_mouse_position(), $MarkerBase.position)
	else:
		if Input.is_mouse_button_pressed(1):
			if type == 0:
				createMele(select, "blue", get_global_mouse_position(), $MarkerEnemy.position)
			elif type == 1:
				createRange(select, "blue", get_global_mouse_position(), $MarkerEnemy.position)
			elif type == 2:
				createShoot(select, "blue", get_global_mouse_position(), $MarkerEnemy.position)
			elif type == 3:
				createSpecial(select, "blue", get_global_mouse_position(), $MarkerEnemy.position)
		if Input.is_mouse_button_pressed(2):
			if type == 0:
				createMele(select, "red", get_global_mouse_position(), $MarkerBase.position)
			elif type == 1:
				createRange(select, "red", get_global_mouse_position(), $MarkerBase.position)
			elif type == 2:
				createShoot(select, "red", get_global_mouse_position(), $MarkerBase.position)
			elif type == 3:
				createSpecial(select, "red", get_global_mouse_position(), $MarkerBase.position)
			
	if Input.is_action_just_pressed("ui_accept"):
		mode = !mode
		
	if test > 0:
		createSpecial(select, "blue", $MarkerBase.position, $MarkerEnemy.position)
		test -= 1

func _on_spin_box_value_changed(value):
	select = str(value)

func _on_spin_box_2_value_changed(value):
	type = int(value)

	
func createSpecial(era, team, posi, dest):
	if ResourceLoader.exists("res://Units/special_units/special_unit_" + era + ".tscn"):
		var unitLoad = load("res://Units/special_units/special_unit_" + era + ".tscn")
		var unit = unitLoad.instantiate()
		unit.position = posi
		unit.destinition = dest
		unit.team = team
		#unit.cooldown = cool
		add_child(unit)
	else: print("resource don't exist")

func createShoot(era, team, posi, dest):
	if ResourceLoader.exists("res://Units/shoot_units/shoot_unit_" + era + ".tscn"):
		var unitLoad = load("res://Units/shoot_units/shoot_unit_" + era + ".tscn")
		var unit = unitLoad.instantiate()
		unit.position = posi
		unit.destinition = dest
		unit.team = team
		#unit.cooldown = cool
		add_child(unit)
	else: print("resource don't exist")

func createRange(era, team, posi, dest):
	if ResourceLoader.exists("res://Units/range_units/range_unit_" + era + ".tscn"):
		var unitLoad = load("res://Units/range_units/range_unit_" + era + ".tscn")
		var unit = unitLoad.instantiate()
		unit.position = posi
		unit.destinition = dest
		unit.team = team
		unit.preBullet = load("res://Units/range_units/range_weapons/bullet_" + era + ".tscn")
		#unit.cooldown = cool
		add_child(unit)
	else: print("resource don't exist")

func createMele(era, team, posi, dest):
	if ResourceLoader.exists("res://Units/mele_units/mele_unit_" + era + ".tscn"):
		var unitLoad = load("res://Units/mele_units/mele_unit_" + era + ".tscn")
		var unit = unitLoad.instantiate()
		unit.position = posi
		unit.destinition = dest
		unit.team = team
		#unit.cooldown = cool
		add_child(unit)
	else: print("resource don't exist")


