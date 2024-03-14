extends Node2D

var preBuy = load("res://GUI/button_buy_unit.tscn")
var preExplosionEffect = load("res://Map/base_explosion.tscn")
var screen_size

var unit_number : int
var max_unit_number: int
var money : float

var buy_buttons = []
var but_buttons_size = 4

func _ready():
	screen_size = Vector2(get_viewport().size.x,get_viewport().size.y)
	#await get_tree().create_timer(0.1).timeout
	#start_game()

func _on_start_button_pressed():
	$UI/StartButton.disabled = true
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property($UI/StartButton, "scale", Vector2(0,0), 0.2)
	var tween2 = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	var temp = Vector2($UI/StartButton.position.x + 150,$UI/StartButton.position.y + 150)
	tween2.tween_property($UI/StartButton, "position", temp, 0.2)
	
	start_game()
	
func start_game():
	$UI/MoneyAnimation.play("show")
	money = 30000
	update_money(money)
	
	unit_number = 1
	get_max_unit_number()
	
	var temp = $Stats.units[0]
	
	var group_bases = get_tree().get_nodes_in_group("bases")
	for i in group_bases:
		remove_child(i)
		i.queue_free()
	var group_enemies = get_tree().get_nodes_in_group("enemies")
	for i in group_enemies:
		i.queue_free()
	var group_team = get_tree().get_nodes_in_group("team")
	for i in group_team:
		i.queue_free()
	change_base(temp, "red", true)
	change_base(temp, "blue", true)

func _on_buy_spawner_timeout():
	if unit_number < $Stats.units.size():
		var temp = $Stats.units[unit_number]
		add_buy_button(temp.price, temp.type, temp.image, unit_number, 5)
		if unit_number <= max_unit_number:
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

#!!!??? można zoptymalizować tą funkcję
func get_max_unit_number(): 
	for i in $Stats.units.size():
		if i >= unit_number:
			if $Stats.units[i].type == "BaseUpgrade":
				max_unit_number = i
				await get_tree().create_timer(0.1).timeout
				_on_buy_spawner_timeout()
				break
			elif i == $Stats.units.size() - 1:
				max_unit_number = i
				await get_tree().create_timer(0.1).timeout
				_on_buy_spawner_timeout()
				break

func add_buy_button(price, description, texture, number, length):
	unit_number += 1
	var buyButton = preBuy.instantiate()
	buyButton.get_node("BottomPanel/Label").text = description
	buyButton.get_node("BottomPanel/TextureRect").texture = load(texture)
	buyButton.connect("hit", buy_unit)
	buyButton.connect("insufficient", buy_unit_insufficient)
	buyButton.number = number
	buyButton.amount = price
	
	buyButton.position = Vector2((buy_buttons.size() * 300) +50, 0)
	if buy_buttons.size() > but_buttons_size - 1: buyButton.position = Vector2((buy_buttons.size() * 300) - 250, 0)
	
	$UI/UnitBuyer.add_child(buyButton)
	buy_buttons.append(buyButton)
	
	if buy_buttons.size() > but_buttons_size:
		var temp = buy_buttons[0]
		buy_buttons.remove_at(0)
		temp.button_kill()
	
	buyButton.button_show()
	for i in buy_buttons.size():
		var temp = buy_buttons[i]
		var where = Vector2((i * 300) + 50, 0)
		var tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(temp, "position", where, 1.0)

func buy_button_remove(which):
	if which >= 0 and which <= buy_buttons.size() - 1:
		var temp = buy_buttons[which]
		buy_buttons.remove_at(which)
		temp.button_kill()

func buy_unit(number, node):
	if number < $Stats.units.size():
		var temp = $Stats.units[number]
		money -= temp.price
		update_money(money)
		if temp.type == "Melee" or temp.type == "Ranger" or temp.type == "Shooter" or temp.type == "Special":
			addUnit(temp, "blue", null)
		elif temp.type == "BaseUpgrade":
			get_max_unit_number()
			change_base(temp, "blue", false)
			buy_button_remove(buy_buttons.find(node))

func buy_unit_insufficient():
	$UI/MoneyAnimation.stop()
	$UI/MoneyAnimation.play("insufficient")

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
			unit.position = $MarkerBase.position + Vector2(0,randi_range(-30,30))
			unit.destinition = $MarkerEnemy.position
		else:
			unit.position = $MarkerEnemy.position + Vector2(0,randi_range(-30,30))
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
			unit.explosion_offset = temp.explosion_offset
			unit.explosive = temp.explosive
			unit.aiming_cooldown = temp.aiming_cooldown
			unit.reload_cooldown = temp.reload_cooldown
		
		add_child(unit)
	else:
		print("resource doesn't exist")

func change_base(temp, team, start):
	if ResourceLoader.exists(temp.path):
		var baseLoad = load(temp.path)
		var base = baseLoad.instantiate()
		
		var old_base = null
		if !start:
			if team == "blue":
				old_base = get_node("Base1")
			else:
				old_base = get_node("Base2")
				base.scale.x = -1
			remove_child(old_base)
			base.max_health = temp.max_health
			base.health = temp.max_health - (old_base.max_health - old_base.health)
			base.team = team
			base.position = old_base.position
			old_base.queue_free()
		else:
			base.start = true
			base.max_health = temp.max_health
			base.health = temp.max_health
			base.team = team
			if team == "blue":
				base.position = $BasePlace1.position
			else:
				base.position = $BasePlace2.position
				base.scale.x = -1
		base.connect("destroyed", game_over)
		base.add_to_group("bases")
		if team == "blue":
			base.name = "Base1"
		else:
			base.name = "Base2"
		add_child(base)
	else:
		print("resource doesn't exist")

func game_over(team):
	print(team)
	$BuySpawner.stop()
	for i in buy_buttons:
		i.button_kill()
	buy_buttons = []
	$UI/MoneyAnimation.stop()
	$UI/MoneyAnimation.play("hide")
	
	var group_bases = get_tree().get_nodes_in_group("bases")
	for i in group_bases:
		i.alive = false
	
	$UI/StartButton.disabled = false
	var tween1 = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween1.tween_property($UI/StartButton, "scale", Vector2(1,1), 0.2)
	var tween2 = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	var temp = Vector2($UI/StartButton.position.x - 150,$UI/StartButton.position.y - 150)
	tween2.tween_property($UI/StartButton, "position", temp, 0.2)
	#!!!??? mayby change so that every unit stops or sth and add !!!ending cutscane
#----------------------------------------------------------------------------------------------------

var mode = false
var reversed = false
var select = 13

func _on_spin_box_value_changed(value):
	select = value

func _process(delta):
	screen_size = Vector2(get_viewport().size.x,get_viewport().size.y)
	$UI/SpinBox.value = select
	if get_global_mouse_position().y > 260 and get_global_mouse_position().y < 680:
		if !mode:
			if Input.is_action_just_pressed("mouse_left_click") and !reversed:
				if $Stats.units.size() > select:
					var temp = $Stats.units[select]
					if temp.type == "Melee" or temp.type == "Ranger" or temp.type == "Shooter" or temp.type == "Special":
						addUnit(temp, "blue", get_global_mouse_position())
			if Input.is_action_just_pressed("mouse_left_click") and reversed:
				if $Stats.units.size() > select:
					var temp = $Stats.units[select]
					if temp.type == "Melee" or temp.type == "Ranger" or temp.type == "Shooter" or temp.type == "Special":
						addUnit(temp, "red", get_global_mouse_position())
			if Input.is_action_just_pressed("mouse_right_click"):
				if $Stats.units.size() > select:
					var temp = $Stats.units[select]
					if temp.type == "Melee" or temp.type == "Ranger" or temp.type == "Shooter" or temp.type == "Special":
						addUnit(temp, "red", get_global_mouse_position())
		else:
			if Input.is_mouse_button_pressed(1) and !reversed:
				if $Stats.units.size() > select:
					var temp = $Stats.units[select]
					if temp.type == "Melee" or temp.type == "Ranger" or temp.type == "Shooter" or temp.type == "Special":
						addUnit(temp, "blue", get_global_mouse_position())
			if Input.is_mouse_button_pressed(1) and reversed:
				if $Stats.units.size() > select:
					var temp = $Stats.units[select]
					if temp.type == "Melee" or temp.type == "Ranger" or temp.type == "Shooter" or temp.type == "Special":
						addUnit(temp, "red", get_global_mouse_position())
			if Input.is_mouse_button_pressed(2):
				if $Stats.units.size() > select:
					var temp = $Stats.units[select]
					if temp.type == "Melee" or temp.type == "Ranger" or temp.type == "Shooter" or temp.type == "Special":
						addUnit(temp, "red", get_global_mouse_position())
	
	if Input.is_action_just_pressed("ui_up"):
		select += 1
	if Input.is_action_just_pressed("ui_down"):
		select -= 1

func _on_button_5_pressed():
	reversed = !reversed
	$UI/Button5.text = "Reversed: " + str(reversed)

func _on_button_6_pressed():
	mode = !mode
	$UI/Button6.text = "Multi: " + str(mode)

func _on_button_pressed():
	for i in range(10):
		await get_tree().create_timer(0.1).timeout
		addUnit($Stats.units[select], "blue", null)
		addUnit($Stats.units[select], "red", null)


func _on_button_2_pressed():
	for i in range(2):
		await get_tree().create_timer(0.1).timeout
		addUnit($Stats.units[select], "blue", null)
		addUnit($Stats.units[select], "red", null)
	for i in range(8):
		await get_tree().create_timer(0.1).timeout
		if (i + 1) % 2 == 0:
			addUnit($Stats.units[select+1], "blue", null)
		addUnit($Stats.units[select], "red", null)


func _on_button_3_pressed():
	for i in range(4):
		await get_tree().create_timer(0.1).timeout
		addUnit($Stats.units[select], "blue", null)
		addUnit($Stats.units[select], "red", null)
	for i in range(6):
		await get_tree().create_timer(0.1).timeout
		if (i + 1) % 2 == 0:
			addUnit($Stats.units[select+1], "blue", null)
		addUnit($Stats.units[select], "red", null)


func _on_button_4_pressed():
	for i in range(10):
		await get_tree().create_timer(0.1).timeout
		if (i + 1) % 2 == 0:
			addUnit($Stats.units[select+1], "blue", null)
		addUnit($Stats.units[select], "red", null)
