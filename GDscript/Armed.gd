extends Weapon
class_name Armed_weapon
 
var animation_player

#weapon status
var is_reload = false
var is_fire = false

# Weapon Parameters
export var ammo_in_mag = 15
export var extra_ammo = 30
onready var mag_size = ammo_in_mag

export var damage = 10
export var fire_rate = 1.0

# Effects
export(PackedScene) var impact_effect
export(NodePath) var muzzle_flash_path
onready var muzzle_flash = get_node(muzzle_flash_path)

#timing weapon change
export var equip_weapon_speed = 1.2
export var unequip_weapon_speed = 1.2
export var reload_speed = 1.0


# Fire Cycle
func fire():
	if not is_reload:
		if ammo_in_mag > 0:
			if not is_fire:
				is_fire = true
				animation_player.get_animation("Fire").loop = true
				animation_player.play("Fire", -1.0, fire_rate)
			
			return
		
		elif is_fire:
			fire_stop()


func fire_stop():
	is_fire = false
	animation_player.get_animation("Fire").loop = false


func fire_bullet():    # Will be called from the animation track
	muzzle_flash.emitting = true
	update_ammo("consume")
	ray.force_raycast_update()
	
	if ray.is_colliding():
		var impact = Global.instantiate_node(impact_effect, ray.get_collision_point())
		impact.emitting = true

# Reload
func reload():
	if ammo_in_mag < mag_size and extra_ammo > 0:
		is_fire = false
		
		animation_player.play("Reload", -1.0, reload_speed)
		is_reload = true


func equip():
	animation_player.play("Equip", -1.0, equip_weapon_speed)
	is_reload = false


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
		"Unequip":
			is_equip = false
		"Equip":
			is_equip = true
		"Reload":
			is_reload = false
			update_ammo("reload")


# Update Ammo
func update_ammo(action = "Refresh", additional_ammo = 0):
	
	match action:
		"consume":
			ammo_in_mag -= 1
		"reload":
			var ammo_needed = mag_size - ammo_in_mag
			
			if extra_ammo > ammo_needed:
				ammo_in_mag = mag_size
				extra_ammo -= ammo_needed
			else:
				ammo_in_mag += extra_ammo
				extra_ammo = 0
		"add":
			extra_ammo += additional_ammo
	
	
	var weapon_data = {
		"Name" : weapon_name,
		"Image" : weapon_image,
		"Ammo" : str(ammo_in_mag),
		"ExtraAmmo" : str(extra_ammo)
	}
	
	weapon_manage.update_hud(weapon_data)
