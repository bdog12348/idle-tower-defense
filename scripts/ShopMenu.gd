extends Control

onready var auto_clicker_price = $MarginContainer/GridContainer/AutoClickerUpgrade/Price
onready var auto_clicker_level = $MarginContainer/GridContainer/AutoClickerUpgrade/Level

const PRICE = "Price: "
const LEVEL = "Level: "

func _ready():
	auto_clicker_price.text = PRICE + str(Data.UpgradePrices.auto_clicker)
	auto_clicker_level.text = LEVEL + str(Data.auto_clickers)
	$MarginContainer/GridContainer/AutoClickerUpgrade.connect("pressed", self, "_on_AutoClickerUprade_pressed")


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		for child in get_children():
			child.queue_free()
		queue_free()
		get_tree().paused = false


func _on_AutoClickerUprade_pressed():
	if Data.gold >= Data.UpgradePrices.auto_clicker:
		Data.gold -= Data.UpgradePrices.auto_clicker
		Data.buy_upgrade(Data.UpgradeTypes.AUTO_CLICKER)
		auto_clicker_price.text = PRICE + str(Data.UpgradePrices.auto_clicker)
		auto_clicker_level.text = LEVEL + str(Data.auto_clickers)
