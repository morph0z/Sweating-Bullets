class_name rail extends Path3D
var mesh:CSGPolygon3D 
var rail_area:railArea
var collision:CollisionShape3D

var nodeCount: float = 0

@export var diameter:float = 0.5
@export var resolution:int = 10

var follow_nodes:Array[railNode]

signal done_grinding

func _ready() -> void:
	create_nodes()
	
	#Visuals
	mesh = CSGPolygon3D.new()
	add_child(mesh)
	mesh.mode = CSGPolygon3D.MODE_PATH
	mesh.path_node = mesh.get_path_to(self)
	mesh.smooth_faces = true
	
	mesh.polygon = PackedVector2Array([
		Vector2(-diameter/2, -diameter/2),
		Vector2(-diameter/2, diameter/2),
		Vector2(diameter/2, diameter/2),
		Vector2(diameter/2, -diameter/2)
	])
	
	#Collisions
	collision = CollisionShape3D.new()
	collision.shape = mesh.bake_collision_shape()
	
	rail_area = railArea.new()
	rail_area.owned_rail = self
	rail_area.name = "Rail Area"
	
	#Add
	add_child(rail_area)
	rail_area.add_child(collision)

var FOLLOW_NODE:PackedScene = preload("uid://dyx6mtwpd4yqf")
func create_nodes() -> Array[railNode]:
	var arr:Array
	
	var path_length:float = curve.get_baked_length()
	var spacing:float = path_length / resolution
	for i in range(resolution):
		var follow_node:railNode = FOLLOW_NODE.instantiate()
		
		add_child(follow_node)
		nodeCount += 1.0
		
		if i > 0: follow_node.progress = spacing * i
		else: follow_node.progress_ratio = (follow_node.end_threshold*0.1)*2
		
		arr.append(follow_node)
		
		follow_node.set_up()
		
		follow_node.reached_end.connect(is_done_grinding)
		follow_node.reached_start.connect(is_done_grinding)
	return arr

func is_done_grinding() -> void:
	done_grinding.emit()
