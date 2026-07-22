class_name PaintBrush
extends RefCounted

var debug_circle: Texture = preload("uid://dvyip3m7d6tnx")


func preview(target: DrawableTexture2D, pos: Vector2, size: Vector2i,  color: Color):
	target.blit_rect(Rect2i(Vector2i(pos) - Vector2i(size * 0.5), size), debug_circle, color)
	pass

func on_start(target: DrawableTexture2D, pos: Vector2, size: Vector2i, color: Color):
	target.blit_rect(Rect2i(Vector2i(pos) - Vector2i(size * 0.5), size), debug_circle, color)

func paint(target: DrawableTexture2D, from: Vector2, to: Vector2, size: Vector2i, color: Color):
	var steps: int = max((from - to).length(), 1)
	var pos_offset := Vector2i(size * 0.5)
	for i: int in range(steps):
		var pos: Vector2i = lerp(to, from, i / float(steps))
		target.blit_rect(Rect2i(Vector2i(pos) - pos_offset, size), debug_circle, color)

func on_end(target: DrawableTexture2D, pos: Vector2, size: Vector2i, color: Color):
		pass
