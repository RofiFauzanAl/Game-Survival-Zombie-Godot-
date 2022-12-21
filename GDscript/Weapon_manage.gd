extends Spatial

var list_weapon = {}

var weapons = {}

var hud

var current_weapon
var weapon_slot = "Empty"


var changing_weapon = false
var unequip_weapon = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	hud = owner.get_node("HUD")
	get_parent().get_node("View fps/RayCast").add_exception(owner)
	
	list_weapon = {
		"pistol" : preload("res://Scene/Weapon/pistol.tscn"),
		"AK_47" : preload("res://Scene/Weapon/AK-47.tscn"),
		"Knife" : preload("res://Scene/Weapon/Knife.tscn")
	}
	
	weapons = {
		"Empty" : $Knife,
		"Primary" : $AK_47,
		"Secondary" : $pistol
	}

	#initialize references for each weapons
	for w in weapons:
		if weapons[w] != null:
			weapons[w].weapon_manage = self
			weapons[w].player = owner
			weapons[w].ray = get_parent().get_node("View fps/RayCast")
			weapons[w].visible = false
	
	#set current weapon to knife
	current_weapon = weapons["Empty"]
	change_weapon("Empty")
	
	#disable process
	set_process(false)


# Firing and Reloading
func fire():
	if not changing_weapon:
		current_weapon.fire()

func fire_stop():
	current_weapon.fire_stop()

func reload():
	if not changing_weapon:
		current_weapon.reload()


func _process(delta):
	if unequip_weapon == false:
		if current_weapon.is_unequip_finished() == false:
			return
		
		unequip_weapon = true
		
		current_weapon= weapons[weapon_slot]
		current_weapon.equip()
	
	if current_weapon.is_equip_finished() == false:
		return
	
	changing_weapon = false
	set_process(false)


func change_weapon(new_weapon_slot):
	if new_weapon_slot == weapon_slot:
		current_weapon.update_ammo()
		return
	
	if weapons[new_weapon_slot] == null:
		return

	weapon_slot = new_weapon_slot
	changing_weapon = true
	
	weapons[weapon_slot].update_ammo()
	
	if current_weapon != null:
		unequip_weapon = false
		current_weapon.unequip()
	
	set_process(true)



func update_hud(weapon_data):
	var weapon_slot_equip = "1"
	
	match weapon_slot:
		"Empty" :
			weapon_slot_equip = "1"
		"Primary" :
			weapon_slot_equip = "2"
		"Secondary" :
			weapon_slot_equip = "3"
	
	hud.update_weapon_ui(weapon_data, weapon_slot)
