extends Button

export (Texture) var buttonImage
export (String) var buttonName
export (String) var keyInDict
export (String, MULTILINE) var tooltip
export (float) var maxLevel

var current_level = 0

onready var _name = $Name
onready var image = $TextureRect

signal upgrade_bought (key, button)


func _ready():
	_name.text = buttonName
	image.texture = buttonImage
	set_tooltip(tooltip)


func _on_Upgrade_pressed():
	if current_level < maxLevel:
		emit_signal("upgrade_bought", keyInDict, self)


func update_level(level):
	current_level = level
	$Level.text = "Level: " + str(level)


func update_price(price):
	$Price.text = "Price: " + str(stepify(price, 0.01))
