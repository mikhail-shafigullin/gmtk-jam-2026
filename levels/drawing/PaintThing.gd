class_name PaintThing
extends Control

@onready var poly: Polygon2D = $PaintThingTexture

func set_texture(texture: Texture2D) -> void:
	poly.texture = texture
	
