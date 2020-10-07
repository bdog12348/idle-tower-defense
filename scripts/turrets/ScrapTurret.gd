extends Turret

func _ready():
	pass


func _process(delta):
	if Input.is_action_just_pressed("m"):
		get_parent().move_target = self
		set_turret_inactive()
