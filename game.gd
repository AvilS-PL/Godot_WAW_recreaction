extends Node2D

var test = 0

var mode = true
var select = "5"
var type = 2

var preBuy = load("res://GUI/button_buy_unit.tscn")
var screen_size
#var buyButtons = []

func _ready():
	screen_size = get_viewport().size
	await get_tree().create_timer(1.0).timeout
	add_buy_button(100, "Melee", "res://Units/melee_units/melee_weapons/melee_weapon_1.png", 1)
	await get_tree().create_timer(3.0).timeout
	add_buy_button(100, "Ranger", "res://Units/ranger_units/ranger_weapons/ranger_weapon_1.png", 123)
	await get_tree().create_timer(3.0).timeout
	add_buy_button(100, "Melee", "res://Units/melee_units/melee_weapons/melee_weapon_3.png", 21)
	await get_tree().create_timer(3.0).timeout
	add_buy_button(100, "Ranger", "res://Units/ranger_units/ranger_weapons/ranger_weapon_3.1.png", 123)
	await get_tree().create_timer(3.0).timeout
	add_buy_button(100, "Ranger", "res://Units/ranger_units/ranger_weapons/ranger_weapon_3.1.png", 123)
	await get_tree().create_timer(3.0).timeout
	add_buy_button(100, "Ranger", "res://Units/ranger_units/ranger_weapons/ranger_weapon_3.1.png", 123)

func add_buy_button(price, description, texture, number):
	var buyButton = preBuy.instantiate()
	print("git")
	buyButton.position = Vector2(1800,400)
	buyButton.get_node("TopPanel/Label").text = ( str(price) + "$")
	buyButton.get_node("BottomPanel/Label").text = description
	buyButton.get_node("BottomPanel/TextureRect").texture = load(texture)
	buyButton.connect("hit", tests)
	buyButton.number = number
	
	$UI/UnitBuyer.add_child(buyButton)
	#buyButtons.append(buyButton)
	
	var tween = create_tween()
	tween.tween_property(buyButton, "position", Vector2(1800,0), 1).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	tween.tween_property(buyButton, "position", Vector2(300,0), 12).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(buyButton, "position", Vector2(300,400), 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_callback(buyButton.queue_free)

func tests(number):
	print(number)

func _process(delta):
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
		
	if test > 0 and test % 4 == 0:
		print(test)
		if type == 0:
			createMele(select, "red", $MarkerEnemy.position + Vector2(0,randi_range(0,10)), $MarkerBase.position)
			createMele(select, "blue", $MarkerBase.position + Vector2(0,randi_range(0,10)), $MarkerEnemy.position)
		elif type == 1:
			createRange(select, "red", $MarkerEnemy.position + Vector2(0,randi_range(0,10)), $MarkerBase.position)
			createRange(select, "blue", $MarkerBase.position + Vector2(0,randi_range(0,10)), $MarkerEnemy.position)
		elif type == 2:
			createShoot(select, "red", $MarkerEnemy.position + Vector2(0,randi_range(0,10)), $MarkerBase.position)
			createShoot(select, "blue", $MarkerBase.position + Vector2(0,randi_range(0,10)), $MarkerEnemy.position)
		elif type == 3:
			createSpecial(select, "red", $MarkerEnemy.position + Vector2(0,randi_range(0,10)), $MarkerBase.position)
			createSpecial(select, "blue", $MarkerBase.position + Vector2(0,randi_range(0,10)), $MarkerEnemy.position)
	test -= 1
	
func createSpecial(era, team, posi, dest):
	if ResourceLoader.exists("res://Units/special_units/special_unit_" + era + ".tscn"):
		var unitLoad = load("res://Units/special_units/special_unit_" + era + ".tscn")
		var unit = unitLoad.instantiate()
		unit.position = posi
		unit.destinition = dest
		unit.team = team
		#unit.cooldown = cool
		add_child(unit)
	else: print("resource doesn't exist")

func createShoot(era, team, posi, dest):
	if ResourceLoader.exists("res://Units/shooter_units/shooter_unit_" + era + ".tscn"):
		var unitLoad = load("res://Units/shooter_units/shooter_unit_" + era + ".tscn")
		var unit = unitLoad.instantiate()
		unit.position = posi
		unit.destinition = dest
		unit.team = team
		#unit.cooldown = cool
		add_child(unit)
	else: print("resource doesn't exist")

func createRange(era, team, posi, dest):
	if ResourceLoader.exists("res://Units/ranger_units/ranger_unit_" + era + ".tscn"):
		var unitLoad = load("res://Units/ranger_units/ranger_unit_" + era + ".tscn")
		var unit = unitLoad.instantiate()
		unit.position = posi
		unit.destinition = dest
		unit.team = team
		unit.preBullet = load("res://Units/ranger_units/ranger_weapons/bullet_" + era + ".tscn")
		#unit.cooldown = cool
		add_child(unit)
	else: print("resource doesn't exist")

func createMele(era, team, posi, dest):
	if ResourceLoader.exists("res://Units/mele_units/mele_unit_" + era + ".tscn"):
		var unitLoad = load("res://Units/mele_units/mele_unit_" + era + ".tscn")
		var unit = unitLoad.instantiate()
		unit.position = posi
		unit.destinition = dest
		unit.team = team
		#unit.cooldown = cool
		add_child(unit)
	else: print("resource doesn't exist")


