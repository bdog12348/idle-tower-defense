extends Button

export (Texture) var buttonImage
export (String) var buttonName
export (String, MULTILINE) var tooltip

onready var _name = $Name
onready var image = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	_name.text = buttonName
	image.texture = buttonImage
	set_tooltip(tooltip)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
