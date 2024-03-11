extends Node
 #!!! do poprawy na icony faktyczne zamiast imageów broni
var units = [
#STONE AGE1:
	#BAT (BASEBALL STICK) MAN
	{
		"type": "Melee",
		"path": "res://Units/melee_units/melee_unit_1.tscn",
		"price": 10,
		"def_speed": 80.0,
		"slow_down": 5.0,
		"max_health": 10.0,
		"damage": 3.0,
		"animation_speed": 1.0,
		"cooldown": 0.2,
		"weight": 60.0,
		"image": "res://Units/melee_units/melee_weapons/melee_weapon_1.png",
	},
	#ROCK THROWER
	{
		"type": "Ranger",
		"path": "res://Units/ranger_units/ranger_unit_1.tscn",
		"price": 20,
		"def_speed": 80.0,
		"slow_down": 5.0,
		"max_health": 4.0,
		"damage": 5.0,
		"animation_speed": 1.0,
		"cooldown": 0.8,
		"weight": 50.0,
		"image": "res://Units/ranger_units/ranger_weapons/ranger_weapon_1.png",
		
		"bullet_speed": 20.0,
		"bullet_rotation": 0,
		"prebullet": "res://Units/ranger_units/ranger_weapons/bullet_1.tscn",
	},
	#DOG
	{
		"type": "Special",
		"path": "res://Units/special_units/special_unit_1.tscn",
		"price": 10,
		"def_speed": 160.0,
		"slow_down": 6.0,
		"max_health": 6.0,
		"damage": 2.0,
		"animation_speed": 1.0,
		"cooldown": 0.1,
		"weight": 20.0,
		"image": "res://Units/special_units/special_1.png",
	},
#BRONZE AGE2:
	#WOODEN BASE
	{
		"type": "BaseUpgrade",
		"path": "res://Map/base_2.tscn",
		"price": 300.0,
		"max_health": 200.0,
		"image": "res://Map/base2/icon.png",
	},
	#SPEAR MAN
	{
		"type": "Melee",
		"path": "res://Units/melee_units/melee_unit_2.tscn",
		"price": 20,
		"def_speed": 80.0,
		"slow_down": 5.0,
		"max_health": 15.0,
		"damage": 6.0,
		"animation_speed": 1.0,
		"cooldown": 0.17,
		"weight": 70.0,
		"image": "res://Units/melee_units/melee_weapons/melee_weapon_2.png",
	},
	#BUMERANGER
	{
		"type": "Ranger",
		"path": "res://Units/ranger_units/ranger_unit_2.tscn",
		"price": 45,
		"def_speed": 80.0,
		"slow_down": 5.0,
		"max_health": 11.0,
		"damage": 10.0,
		"animation_speed": 1.0,
		"cooldown": 1.0,
		"weight": 50.0,
		"image": "res://Units/ranger_units/ranger_weapons/ranger_weapon_2.png",
		
		"bullet_speed": 10.0,
		"bullet_rotation": 10.0,
		"prebullet": "res://Units/ranger_units/ranger_weapons/bullet_2.tscn",
	},
#MEDIEVAL AGE3:
	#CASTLE BASE
	{
		"type": "BaseUpgrade",
		"path": "res://Map/base_3.tscn",
		"price": 800.0,
		"max_health": 400.0,
		"image": "res://Map/base3/icon.png",
	},
	#SWORDSMAN
	{
		"type": "Melee",
		"path": "res://Units/melee_units/melee_unit_3.tscn",
		"price": 45,
		"def_speed": 80.0,
		"slow_down": 5.0,
		"max_health": 30.0,
		"damage": 11.0,
		"animation_speed": 1.0,
		"cooldown": 0.12,
		"weight": 80.0,
		"image": "res://Units/melee_units/melee_weapons/melee_weapon_3.png",
	},
	#BOW MASTER
	{
		"type": "Ranger",
		"path": "res://Units/ranger_units/ranger_unit_3.tscn",
		"price": 100,
		"def_speed": 80.0,
		"slow_down": 5.0,
		"max_health": 20.0,
		"damage": 16.0,
		"animation_speed": 1.0,
		"cooldown": 0.75,
		"weight": 50.0,
		"image": "res://Units/ranger_units/ranger_weapons/ranger_weapon_3.1.png",
		
		"bullet_speed": 20.0,
		"bullet_rotation": 0,
		"prebullet": "res://Units/ranger_units/ranger_weapons/bullet_3.tscn",
	},
	#HORSE RIDER
	{
		"type": "Special",
		"path": "res://Units/special_units/special_unit_3.tscn",
		"price": 200,
		"def_speed": 160.0,
		"slow_down": 6.0,
		"max_health": 88.0,
		"damage": 30.0,
		"animation_speed": 1.1,
		"cooldown": 0.3,
		"weight": 300.0,
		"image": "res://Units/special_units/special_3.1.png",
	},
#RENAISSANSE AGE4:
	#MONUMENT BASE
	{
		"type": "BaseUpgrade",
		"path": "res://Map/base_4.tscn",
		"price": 1500.0,
		"max_health": 700.0,
		"image": "res://Map/base4/icon.png"
	},
	#FENCER
	{
		"type": "Melee",
		"path": "res://Units/melee_units/melee_unit_4.tscn",
		"price": 100,
		"def_speed": 90.0,
		"slow_down": 5.0,
		"max_health": 40.0,
		"damage": 12.0,
		"animation_speed": 1.3,
		"cooldown": 0.1,
		"weight": 70.0,
		"image": "res://Units/melee_units/melee_weapons/melee_weapon_4.png",
	},
	#SHOOTER1
	{
		"type": "Shooter",
		"path": "res://Units/shooter_units/shooter_unit_4.tscn",
		"price": 160,
		"def_speed": 90.0,
		"slow_down": 5.0,
		"max_health": 24.0,
		"damage": 20.0,
		"animation_speed": 1.0,
		"cooldown": 2.0,
		"aiming_cooldown": 0.5,
		"reload_cooldown": 1.0,
		"weight": 50.0,
		"image": "res://Units/shooter_units/shooter_weapons/shooter_weapon_4.1.png",
		
		"bullet_speed": 20.0,
		"bullet_size": 5.0,
		"rotation_speed": 5.0,
		"explosion_offset": 0.1,
		"explosive": 0.0,
	},
	#CANNON MAN
	{
		"type": "Shooter",
		"path": "res://Units/special_units/special_unit_4.tscn",
		"price": 300,
		"def_speed": 50.0,
		"slow_down": 5.0,
		"max_health": 60.0,
		"damage": 40.0,
		"animation_speed": 1.0,
		"cooldown": 1.0, #!!! it must be separeted to reload cooldown and aiming cooldown
		"aiming_cooldown": 1.0,
		"reload_cooldown": 3.0,
		"weight": 50.0,
		"image": "res://Units/special_units/special_4.png",
		
		"bullet_speed": 10.0,
		"bullet_size": 20.0,
		"rotation_speed": 1.0,
		"explosion_offset": 0.0,
		"explosive": 4,
	},
]
