extends Node2D

var preBuy = load("res://GUI/button_buy_unit.tscn")
var screen_size

var unit_number = 0
var money : float = 100

func _ready():
	update_money(money)
	screen_size = get_viewport().size
	await get_tree().create_timer(2.0).timeout
	start_game()

func start_game():
	_on_buy_spawner_timeout()

func _on_buy_spawner_timeout():
	if unit_number < $Stats.units.size():
		var temp = $Stats.units[unit_number]
		add_buy_button(temp.price, temp.type, temp.weapon, unit_number, 5)
		$BuySpawner.start()

func update_money(amount):
	var letter = ""
	if amount >= 1000:
		letter = "k"
		amount = floor(amount / 10) / 100
		if amount >= 1000:
			letter = "m"
			amount = floor(amount / 10) / 100
	$UI/Money/Label.text = str(amount) + letter + " $"


func add_buy_button(price, description, texture, number, len):
	unit_number += 1
	var buyButton = preBuy.instantiate()
	buyButton.position = Vector2(1600,200)
	buyButton.get_node("BottomPanel/Label").text = description
	buyButton.get_node("BottomPanel/TextureRect").texture = load(texture)
	buyButton.connect("hit", buy_unit)
	buyButton.number = number
	buyButton.amount = price
	
	$UI/UnitBuyer.add_child(buyButton)
	
	var tween = create_tween()
	tween.tween_property(buyButton, "position", Vector2(1600,0), 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(buyButton, "position", Vector2(120,0), len).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(buyButton, "position", Vector2(120,200), 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	tween.tween_callback(buyButton.queue_free)

func buy_unit(number):
	if number < $Stats.units.size():
		var temp = $Stats.units[number]
		if temp.price <= money:
			money -= temp.price
			update_money(money)
			if ResourceLoader.exists(temp.path):
				addUnit(temp, "blue")
			else: print("resource doesn't exist")
		else:
			$UI/MoneyAnimation.play("insufficient")
			#???!!! maybe add also animation to button itself?
			
func addUnit(temp, team):
	var unitLoad = load(temp.path)
	var unit = unitLoad.instantiate()
	
	unit.team = team
	unit.def_speed = temp.def_speed
	unit.slow_down = temp.slow_down
	unit.max_health = temp.max_health
	unit.damage = temp.damage
	unit.animation_speed = temp.animation_speed
	unit.cooldown = temp.cooldown
	unit.weight = temp.weight
	
	if team == "blue":
		unit.position = $MarkerBase.position + Vector2(0,randi_range(0,10))
		unit.destinition = $MarkerEnemy.position
	else:
		unit.position = $MarkerEnemy.position + Vector2(0,randi_range(0,10))
		unit.destinition = $MarkerBase.position
	
	if temp.type == "Ranger" :
		unit.bullet_speed = temp.bullet_speed
		unit.bullet_rotation = temp.bullet_rotation
		unit.preBullet = load(temp.prebullet)
	elif temp.type == "Shooter":
		unit.cooldown = temp.cooldown
	
	print(temp.def_speed)
	add_child(unit)

#----------------------------------------------------------------------------------------------------

var test = 0

var mode = true
var select = "1"
var type = 0

func _process(delta):
	if mode: 
		#if Input.is_action_just_pressed("mouse_left_click"):
			#if type == 0:
				#createMele(select, "blue", get_global_mouse_position(), $MarkerEnemy.position)
			#elif type == 1:
				#createRange(select, "blue", get_global_mouse_position(), $MarkerEnemy.position)
			#elif type == 2:
				#createShoot(select, "blue", get_global_mouse_position(), $MarkerEnemy.position)
			#elif type == 3:
				#createSpecial(select, "blue", get_global_mouse_position(), $MarkerEnemy.position)
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
		#if Input.is_mouse_button_pressed(1):
			#if type == 0:
				#createMele(select, "blue", get_global_mouse_position(), $MarkerEnemy.position)
			#elif type == 1:
				#createRange(select, "blue", get_global_mouse_position(), $MarkerEnemy.position)
			#elif type == 2:
				#createShoot(select, "blue", get_global_mouse_position(), $MarkerEnemy.position)
			#elif type == 3:
				#createSpecial(select, "blue", get_global_mouse_position(), $MarkerEnemy.position)
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
	if ResourceLoader.exists("res://Units/melee_units/melee_unit_" + era + ".tscn"):
		var unitLoad = load("res://Units/melee_units/melee_unit_" + era + ".tscn")
		var unit = unitLoad.instantiate()
		unit.position = posi
		unit.destinition = dest
		unit.team = team
		#unit.cooldown = cool
		add_child(unit)
	else: print("resource doesn't exist")
