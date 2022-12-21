extends Spatial
class_name Weapon

var weapon_manage = null
var player = null
var ray = null


#weapon status
var is_equip = false

export var weapon_name = "Weapon"
export(Texture) var weapon_image = null


func equip():
	pass
	

func unequip():
	pass

func is_equip_finished():
	return true

func is_unequip_finished():
	return true

# Update Ammo
func update_ammo(action = "Refresh"):
	
	var weapon_data = {
		"Name" : weapon_name,
		"Image" : weapon_image
	}

	weapon_manage.update_hud(weapon_data)
