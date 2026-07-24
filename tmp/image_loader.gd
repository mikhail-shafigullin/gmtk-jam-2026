extends Control

@onready var label: Label = $Label
@onready var trect: TextureRect = $TextureRect

func _ready() -> void:
	load_img()

func load_img():
	var data := PaintingLoader.read_temp_file()
	trect.texture = data.texture
	data.texture = null
	label.text = var_to_str(data)
	
