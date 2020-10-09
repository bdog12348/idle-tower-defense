tool

extends Button

export (NodePath) var previous_node
export (Texture) var buttonImage
export (String) var buttonName
export (String) var keyInDict
export (String, MULTILINE) var tooltip
export (float) var maxLevel

export (bool) var unlocked = false setget set_unlocked
export (bool) var learned = false

var current_level = 0

onready var _name = $Name
onready var image = $TextureRect

signal on_learned ()
signal upgrade_bought (key, button)


func _init():
	set_tooltip(tooltip)


func _ready():
	_name.text = buttonName
	image.texture = buttonImage
	refresh_line()
	if previous_node:
		get_node(previous_node).connect("on_learned", self, "on_learned")


func _process(_delta):
	if not Engine.is_editor_hint():
		return
	refresh_line()


func set_unlocked(_unlocked):
	unlocked = _unlocked
	disabled = !unlocked
	if unlocked:
		set_active()
	else:
		set_inactive()


func set_active():
	modulate = Color(1,1,1,1)


func set_inactive():
	modulate = Color(0.6,0.6,0.6,1)


func _on_Upgrade_pressed():
	if current_level < maxLevel:
		emit_signal("upgrade_bought", keyInDict, self)
	learned = true
	emit_signal("on_learned")


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
	
	
func on_learned():
	set_unlocked(true)
	emit_signal("on_unlocked")
	print("Skill_Node %s unlocked" % name)


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
