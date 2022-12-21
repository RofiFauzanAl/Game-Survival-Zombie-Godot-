extends Spatial
class_name Weapon

var weapon_manage = null
var player = null 
var animation_player


#weapon status
var is_equip = false
var is_fire = false


export var weapon_name = "Weapon"

#timing weapon change
export var equip_weapon_speed = 1.2
export var unequip_weapon_speed = 1.2


func equip():
	animation_player.play("Equip", -1.0, equip_weapon_speed)
	

func unequip():
	animation_player.play("Unequip", -1.0, unequip_weapon_speed)

func is_equip_finished():
	if is_equip:
		return false
	else:
		return true

func is_unequip_finished():
	if is_equip:
		return false
	else:
		return true


func show_weapon():
	visible = true

func hide_weapon():
	visible = false


func on_animation_finish(anim_name):
	match anim_name:
		"Unequip" :
			is_equip = false
		"Equip" :
			is_equip = true

#update ammo
func update_ammo(action = "Refresh"):
	var weapon_data = {
		"Name" : weapon_name 
	}
	
	weapon_manage.update_hud(weapon_data)
