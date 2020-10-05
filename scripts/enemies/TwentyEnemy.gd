extends Enemy

onready var enemy_manager = $"../../../../../EnemyManager"


func _ready():
	pass

func destroy():
	.destroy()
	enemy_manager.make_enemy(Data.EnemyTypes.TEN_ENEMY, get_parent().offset, 2)
