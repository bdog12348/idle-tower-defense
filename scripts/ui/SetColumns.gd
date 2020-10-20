extends Panel

const BUTTON_WIDTH = 90

onready var marginContainer = get_node("MarginContainer")
onready var gridContainer = get_node("MarginContainer/ScrollContainer/GridContainer")

func _ready():
	update_columns()
	
func update_columns():
	var workable_space = rect_size.x - marginContainer.get_constant("margin_right") - marginContainer.get_constant("margin_left")
	var new_num_columns = 1
	var used_space = BUTTON_WIDTH * new_num_columns + gridContainer.get_constant("hseparation") * new_num_columns
	while used_space < workable_space - BUTTON_WIDTH:
		new_num_columns += 1
		used_space = BUTTON_WIDTH * new_num_columns + gridContainer.get_constant("hseparation") * new_num_columns
	var leftOverSpace = workable_space - used_space
	print("ended using %d out of %d, %d left" % [used_space, workable_space, workable_space - leftOverSpace])
	print("left %d, right %d" % [marginContainer.get_constant("margin_left"), marginContainer.get_constant("margin_right")])
	marginContainer.add_constant_override("margin_right", marginContainer.get_constant("margin_right") + leftOverSpace / 2)
	marginContainer.add_constant_override("margin_left", marginContainer.get_constant("margin_left") + leftOverSpace / 2)
	#marginContainer.add_constant_override("margin_left", 100)
	print("left %d, right %d" % [marginContainer.get_constant("margin_left"), marginContainer.get_constant("margin_right")])
	gridContainer.columns = new_num_columns
