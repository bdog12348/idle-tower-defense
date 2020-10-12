extends Button

export (NodePath) var previous_node
export (Texture) var buttonImage
export (String) var buttonName
export (String) var keyInDict
export (String, MULTILINE) var tooltip
export (float) var maxLevel

var current_level = 0

onready var _name = $Name
onready var image = $TextureRect

signal upgrade_bought (key, button)


func _init():
	set_tooltip(tooltip)


func _ready():
	_name.text = buttonName
	image.texture = buttonImage


func _on_Upgrade_pressed():
	if current_level < maxLevel:
		emit_signal("upgrade_bought", keyInDict, self)


func refresh_line(): #this sets the line2d to be connected with the previous_node
	if not previous_node:
		return
	var line = $Line2D
	var target_pos = get_node(previous_node).rect_global_position
	var line_point = target_pos - rect_global_position
	var points = line.points
	if points.size() > 1:
		points.remove(1)
	points.append(line_point)
	line.points = points


func update_level(level):
	current_level = level
	if current_level == maxLevel:
			$Level.text = "Level: MAX"
	else:
		$Level.text = "Level: " + str(level)


func update_price(price):
	if current_level == maxLevel:
		$Price.text = "Price: --"
	else:
		$Price.text = "Price: " + str(stepify(price, 0.01))
