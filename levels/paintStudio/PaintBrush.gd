class_name PaintBrush
extends RefCounted


func preview(target: DrawableTexture2D, pos: Vector2, size: int,  color: Color):
	pass

func on_start(target: DrawableTexture2D, pos: Vector2, size: int, color: Color):
	pass

func paint(target: DrawableTexture2D, from: Vector2, to: Vector2, size: int, color: Color):
	pass

func on_end(target: DrawableTexture2D, pos: Vector2, size: int, color: Color):
	pass
