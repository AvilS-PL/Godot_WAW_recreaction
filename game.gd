extends Node2D

var preBuy = load("res://GUI/button_buy_unit.tscn")
var screen_size

var unit_number = 0
var money : float = 1000

func _ready():
	update_money(money)
	$Base1.connect("destroyed", game_over)
	$Base2.connect("destroyed", game_over)
	screen_size = get_viewport().size
	
	await get_tree().create_timer(0.1).timeout
	start_game()

func start_game():
	_on_buy_spawner_timeout()

func _on_buy_spawner_timeout():
	if unit_number < $Stats.units.size():
		var temp = $Stats.units[unit_number]
		add_buy_button(temp.price, temp.type, temp.image, unit_number, 5)
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
			if temp.type == "Melee" or temp.type == "Ranger" or temp.type == "Shooter":
				addUnit(temp, "blue", null)
			elif temp.type == "BaseUpgrade":
				change_base(temp, "blue")
		else:
			$UI/MoneyAnimation.play("insufficient")
			#???!!! maybe add also animation to button itself?
			
func addUnit(temp, team, pos):
	if ResourceLoader.exists(temp.path):
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
		if pos != null:
			unit.position = pos
		
		if temp.type == "Ranger" :
			unit.bullet_speed = temp.bullet_speed
			unit.bullet_rotation = temp.bullet_rotation
			unit.preBullet = load(temp.prebullet)
		elif temp.type == "Shooter":
			unit.bullet_speed = temp.bullet_speed
			unit.rotation_speed = temp.rotation_speed
			unit.bullet_size = temp.bullet_size
		
		add_child(unit)
	else:
		print("resource doesn't exist")

func change_base(temp, team):
	if ResourceLoader.exists(temp.path):
		var baseLoad = load(temp.path)
		var base = baseLoad.instantiate()
		
		var old_base = null
		if team == "blue":
			old_base = get_node("Base1")
		else:
			old_base = get_node("Base2")
			base.scale.x = -1
		remove_child(old_base)
		
		base.team = team
		base.name = old_base.name
		base.position = old_base.position
		base.connect("destroyed", game_over)
		
		add_child(base)
	else:
		print("resource doesn't exist")

func game_over(team):
	print(team)
	$BuySpawner.stop()
	#!!! game over mechanics needed
#----------------------------------------------------------------------------------------------------

var test = 0

var mode = true
var select = 10

func _on_spin_box_value_changed(value):
	select = value

func _process(delta):
	if mode: 
		#if Input.is_action_just_pressed("mouse_left_click"):
		if Input.is_action_just_pressed("mouse_right_click"):
			if $Stats.units.size() > select:
				addUnit($Stats.units[select], "red", get_global_mouse_position())
	else:
		#if Input.is_mouse_button_pressed(1):
		if Input.is_mouse_button_pressed(2):
			if $Stats.units.size() > select:
				addUnit($Stats.units[select], "red", get_global_mouse_position())
			
	if Input.is_action_just_pressed("ui_accept"):
		mode = !mode
		
	if test > 0 and test % 4 == 0:
		print(test)
	test -= 1
