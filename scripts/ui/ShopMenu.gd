extends Control

onready var auto_clicker = $MarginContainer/TabContainer/ScrollContainer/Upgrades/AutoClickerUpgrade
onready var click_power = $MarginContainer/TabContainer/ScrollContainer/Upgrades/ClickPowerUpgrade

onready var tab_container = $MarginContainer/TabContainer


func _ready():
	init_upgrades(self)


func _unhandled_input(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
	invis()


func button_pressed(key, button):
	if Data.gold >= Data.Upgrades[key].price:
		Data.gold -= Data.Upgrades[key].price
		Data.buy_upgrade(Data.Upgrades[key].type)
		button.update_level(Data.Upgrades[key].current_amount)
		button.update_price(Data.Upgrades[key].price)


func invis():
	visible = false
	get_tree().paused = false
	
	
func init_upgrades(node):
	for N in node.get_children():
		if N.get_child_count() > 0:
			if N.is_in_group("BasicTurretUpgrades"):
				pass
			if N.is_in_group("Upgrade"):
				print("found upgrade")
				N.update_level(Data.Upgrades[N.keyInDict].current_amount)
				N.update_price(Data.Upgrades[N.keyInDict].price)
				N.connect("upgrade_bought", self, "button_pressed")
				
			init_upgrades(N)
		else:
			pass
