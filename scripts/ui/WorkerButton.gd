extends Button

export (Texture) var buttonImage
export (String, MULTILINE) var tooltip

var current_num_owned = 0
var current_price = 0

onready var _name = $Name
onready var image = $TextureRect

signal upgrade_bought (key, button)


func _init():
	set_tooltip(tooltip)


func _ready():
	_name.text = "Worker"
	image.texture = buttonImage
	update_owned_price()


func _on_Upgrade_pressed():
	if Data.gold >= current_price:
		Data.buy_worker()
		update_owned_price()


func update_owned_price():
	var num = Data.workers_owned
	var price = Data.worker_current_price
	current_num_owned = num
	$Owned.text = "Owned: " + str(num)
	current_price = price
	$Price.text = "Price: " + str(stepify(price, 0.01))
