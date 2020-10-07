extends Control

onready var auto_clicker = $MarginContainer/TabContainer/ScrollContainer/Upgrades/AutoClickerUpgrade
onready var click_power = $MarginContainer/TabContainer/ScrollContainer/Upgrades/ClickPowerUpgrade

onready var tab_container = $MarginContainer/TabContainer


func _ready():
	for frame in tab_container.get_children():
		for box in frame.get_children():
			for child in box.get_children():
				child.update_level(Data.Upgrades[child.keyInDict].current_amount)
				child.update_price(Data.Upgrades[child.keyInDict].price)
				child.connect("upgrade_bought", self, "button_pressed")


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
