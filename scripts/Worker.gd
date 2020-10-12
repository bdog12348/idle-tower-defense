extends Sprite

onready var tilemap = get_parent()#.get_node("Navigation2D/TileMap")
onready var nav2d = get_parent().get_parent()

var towers
var target
var path
var speed = 40

func _ready():
	if tilemap:
		towers = tilemap.get_node("TowerManager").get_children()


func _process(delta):
	if towers.size() > 0 and target == null:
		get_target()

	if target != null and path == null:
		path = nav2d.get_simple_path(position, target.position, true)

	if path != null and target != null:
		var move_distance = speed * delta
		move_along_path(move_distance)


func move_along_path(distance):
	var start_point = position
	for i in range(path.size()):
		var distance_to_next = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = start_point.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif distance < 0.0:
			position = path[0]
			break
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)


func _on_Area2D_area_entered(area):
	var tower = area.get_parent()
	if tower.is_in_group("Tower"):
		tower.set_manned()
		hide()


func get_target():
	var closestTower = towers[0]
	var i = 0
	while closestTower.worker != null and i < towers.size() - 1:
		i += 1
		closestTower = towers[i]

	for tower in towers:
		if tower.worker == null and closestTower != tower:
			var distance = tower.position.distance_to(position)
			var closestDistance = closestTower.position.distance_to(position)
			if distance < closestDistance:
				closestTower = tower

	if closestTower.worker == null:
		target = closestTower
		target.worker = self
