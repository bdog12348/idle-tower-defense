extends Control

onready var auto_clicker = $MarginContainer/TabContainer/Clicks/AutoClickerUpgrade
onready var click_power = $MarginContainer/TabContainer/Clicks/ClickPowerUpgrade

onready var tab_container = $MarginContainer/TabContainer


func _ready():
	for frame in tab_container.get_children():
		for child in frame.get_children():
			child.update_level(Data.Upgrades[child.keyInDict].current_amount)
			child.update_price(Data.Upgrades[child.keyInDict].price)
			child.connect("upgrade_bought", self, "button_pressed")


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		visible = false


func _unhandled_input(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
		
	visible = false


func button_pressed(key, button):
	if Data.gold >= Data.Upgrades[key].price:
		Data.gold -= Data.Upgrades[key].price
		Data.buy_upgrade(Data.Upgrades[key].type)
		button.update_level(Data.Upgrades[key].current_amount)
		button.update_price(Data.Upgrades[key].price)
