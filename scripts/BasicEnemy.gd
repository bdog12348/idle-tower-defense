extends Enemy

func _process(delta):
	pass

func destroy():
	.destroy()
	Data.addEnemiesKilled(Data.EnemyTypes.BASIC_ENEMY, 1)
