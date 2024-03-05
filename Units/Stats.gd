extends Node

var units = [
#STONE AGE:
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
		"cooldown": 0.1,
		"weight": 60.0,
		"weapon": "res://Units/melee_units/melee_weapons/melee_weapon_1.png",
	},
	#ROCK THROWER
	{
		"type": "Ranger",
		"path": "res://Units/ranger_units/ranger_unit_1.tscn",
		"price": 20,
		"def_speed": 80.0,
		"slow_down": 5.0,
		"max_health": 5.0,
		"damage": 5.0,
		"animation_speed": 1.0,
		"cooldown": 0.1,
		"weight": 50.0,
		"weapon": "res://Units/ranger_units/ranger_weapons/ranger_weapon_1.png",
		
		"bullet_speed": 20.0,
		"bullet_rotation": 0,
		"prebullet": "res://Units/ranger_units/ranger_weapons/bullet_1.tscn",
	},
	#DOG
	{
		"type": "Special",
		"path": "res://Units/special_units/special_unit_1.tscn",
		"price": 5,
		"def_speed": 160.0,
		"slow_down": 6.0,
		"max_health": 6.0,
		"damage": 2.0,
		"animation_speed": 1.0,
		"cooldown": 0.1,
		"weight": 20.0,
		"weapon": "res://Units/special_units/special_1.png",
		
		"bullet_speed": 20.0,
		"bullet_size": 5.0,
	},
]
