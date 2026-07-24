class_name LineBrush
extends PaintBrush

const square_texture := preload("res://levels/paintStudio/Brushes/textures/1x1.png")
const sizes: Array[int] = [
	1,
	2,
	5,
	7,
	9,
	11,
	13,
	15,
	17
]

var _start_pos: Vector2i = Vector2i(-1, -1)

func preview(target: DrawableTexture2D, pos: Vector2, size: int,  color: Color):
	if min(_start_pos.x, _start_pos.y) >= 0:
		blit_line(target, _start_pos, pos, size, color)
	else:
		var s := _get_size(size)
		var pos_offset := Vector2i.ONE * floori(s.x * 0.5)
		var brect := Rect2i(Vector2i(pos) - pos_offset, s)
		target.blit_rect(brect, square_texture, color)


func on_start(target: DrawableTexture2D, pos: Vector2, size: int, color: Color):
	_start_pos = Vector2i(pos)
		
func on_end(target: DrawableTexture2D, pos: Vector2, size: int, color: Color):
	blit_line(target, _start_pos, Vector2i(pos), size, color)
	_start_pos = Vector2i(-1, -1)

func blit_line(target: DrawableTexture2D, from: Vector2, to: Vector2, size: int,  color: Color):
		var length := (to - from).length()
		var steps: int = max(ceili(length), 1)
		var s := _get_size(size)
		var pos_offset := Vector2i.ONE * floori(s.x * 0.5)
		for i: int in range(steps):
			var blend := i / float(steps)
			var pos = lerp(from, to, blend)
			var brect := Rect2i(Vector2i(pos) - pos_offset, s)
			target.blit_rect(brect, square_texture, color)


func _get_size(size: int) -> Vector2i:
	return Vector2i.ONE * sizes[(clampi(size, 1, 9)-1)]
