extends Armed_weapon

func _ready():
	animation_player = $AnimationPlayer
	animation_player.connect("animation_finished", self, "on_animation_finish")

func on_animation_finisih(anim_name):
	.on_animation_finish(anim_name)
