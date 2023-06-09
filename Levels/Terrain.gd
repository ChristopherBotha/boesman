extends MeshInstance3D


@onready var colShape: CollisionShape3D = $StaticBody3D/CollisionShape3D
@export var chunk_size = 2.0
@export var height_ratio = 1.0
@export var colShape_size_ratio = 0.1

var img = Image.new()
var shape = HeightMapShape3D.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	colShape.shape = shape
	mesh.size = Vector2(chunk_size,chunk_size)
	update_terrain(height_ratio, colShape_size_ratio)

func update_terrain(_height_ratio, _colShape_size_ratio)-> void:
	material_override.set("shader_parameter/height_ratio",_height_ratio)
	img.load("res://Levels/landscape_4k_displacement.png")
	img.convert(Image.FORMAT_RF)
	img.resize(img.get_width()*_colShape_size_ratio, img.get_height()*_colShape_size_ratio)
	var data = img.get_data().to_float32_array()
	for i in range(0, data.size()):
		data[i] *= _height_ratio
	shape.map_width = img.get_width()
	shape.map_depth = img.get_height()
	shape.map_data = data
	colShape.shape = shape
	var scale_ratio = chunk_size/float(img.get_width())
	colShape.scale = Vector3(scale_ratio,1,scale_ratio)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
