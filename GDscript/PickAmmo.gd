extends Area

export(int) var ammo = 10


func _on_Area_body_entered(body):
	pass # Replace with function body.
	if body.name == "Player":
		var result = body.weapon_manager.add_ammo(ammo)
		
		if result:
			queue_free()
