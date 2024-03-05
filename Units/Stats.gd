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
		"cooldown": 1.0,
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
		"price": 100,
		"image": "res://Map/base2/base1.png", #!!! do poprawy na icon
	},
	#SPEAR MAN
	{
		"type": "Melee",
		"path": "res://Units/melee_units/melee_unit_2.tscn",
		"price": 20,
		"def_speed": 80.0,
		"slow_down": 5.0,
		"max_health": 15.0,
		"damage": 5.0,
		"animation_speed": 1.0,
		"cooldown": 0.19,
		"weight": 70.0,
		"image": "res://Units/melee_units/melee_weapons/melee_weapon_2.png",
	},
	#BUMERANGER
	{
		"type": "Ranger",
		"path": "res://Units/ranger_units/ranger_unit_2.tscn",
		"price": 50,
		"def_speed": 80.0,
		"slow_down": 5.0,
		"max_health": 8.0,
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
	#SWORDSMAN
	{
		"type": "Melee",
		"path": "res://Units/melee_units/melee_unit_3.tscn",
		"price": 10,
		"def_speed": 80.0,
		"slow_down": 5.0,
		"max_health": 10.0,
		"damage": 3.0,
		"animation_speed": 1.0,
		"cooldown": 0.2,
		"weight": 60.0,
		"image": "res://Units/melee_units/melee_weapons/melee_weapon_3.png",
	},
	#BOW MASTER
	{
		"type": "Ranger",
		"path": "res://Units/ranger_units/ranger_unit_3.tscn",
		"price": 20,
		"def_speed": 80.0,
		"slow_down": 5.0,
		"max_health": 4.0,
		"damage": 5.0,
		"animation_speed": 1.0,
		"cooldown": 1.0,
		"weight": 50.0,
		"image": "res://Units/ranger_units/ranger_weapons/ranger_weapon_3.1.png",
		
		"bullet_speed": 20.0,
		"bullet_rotation": 0,
		"prebullet": "res://Units/ranger_units/ranger_weapons/bullet_2.tscn",
	},
	#HORSE RIDER
	{
		"type": "Special",
		"path": "res://Units/special_units/special_unit_3.tscn",
		"price": 10,
		"def_speed": 160.0,
		"slow_down": 6.0,
		"max_health": 6.0,
		"damage": 2.0,
		"animation_speed": 1.0,
		"cooldown": 0.1,
		"weight": 20.0,
		"image": "res://Units/special_units/special_3.1.png",
	},
#RENAISSANSE AGE4:
	#FENCER
	{
		"type": "Melee",
		"path": "res://Units/melee_units/melee_unit_4.tscn",
		"price": 10,
		"def_speed": 80.0,
		"slow_down": 5.0,
		"max_health": 10.0,
		"damage": 3.0,
		"animation_speed": 1.0,
		"cooldown": 0.2,
		"weight": 60.0,
		"image": "res://Units/melee_units/melee_weapons/melee_weapon_4.png",
	},
	#SHOOTER1
	{
		"type": "Shooter",
		"path": "res://Units/shooter_units/shooter_unit_4.tscn",
		"price": 20,
		"def_speed": 80.0,
		"slow_down": 5.0,
		"max_health": 4.0,
		"damage": 5.0,
		"animation_speed": 1.0,
		"cooldown": 1.0,
		"weight": 50.0,
		"image": "res://Units/shooter_units/shooter_weapons/shooter_weapon_4.1.png",
		
		"bullet_speed": 20.0,
		"bullet_size": 5.0,
		"rotation_speed": 5.0,
	},
	#TO BE ADDED...
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
]
