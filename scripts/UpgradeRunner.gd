extends Node2D

onready var area2d = $"../Map/TileMap/Area2D"

signal bought_upgrade (type)

var auto_clicker_base_time = 2

func _ready():
	$"/root/Data".connect("bought_upgrade", self, "update_buys")


func update_buys(type):
	match type:
		Data.UpgradeTypes.AUTO_CLICKER:
			var numMult = Data.Upgrades.auto_clicker.current_amount - 1
			var autoClickerTime = auto_clicker_base_time - (numMult * .05)
			print("setting auto clicker timer to " + str(autoClickerTime))
			$AutoClickTimer.start(autoClickerTime)
		Data.UpgradeTypes.CLICK_POWER:
			Data.click_damage += float(.25)
			print("setting click damage to " + str(Data.click_damage))


func _on_AutoClickTimer_timeout():
	$"../EnemyManager".attack_enemy(area2d.position)
