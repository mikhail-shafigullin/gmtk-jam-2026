class_name SquareBrush
extends PaintBrush

const square_texture := preload("res://levels/paintStudio/Brushes/textures/1x1.png")
const sizes: Array[int] = [
	1,
	3,
	5,
	7,
	9,
	11,
	13,
	15,
	17
]


func preview(target: DrawableTexture2D, pos: Vector2, size: int,  color: Color):
	var s := _get_size(size)
	var pos_offset := Vector2i.ONE * floori(s.x * 0.5)
	var brect := Rect2i(Vector2i(pos) - pos_offset, s)
	target.blit_rect(brect, square_texture, color)

func on_start(target: DrawableTexture2D, pos: Vector2, size: int, color: Color):
	var s := _get_size(size)
	var pos_offset := Vector2i.ONE * floori(s.x * 0.5)
	var brect := Rect2i(Vector2i(pos) - pos_offset, s)
	target.blit_rect(brect, square_texture, color)

func paint(target: DrawableTexture2D, from: Vector2, to: Vector2, size: int, color: Color):
	var s := _get_size(size)
	var steps: int = max((from - to).length(), 1)
	var pos_offset := Vector2i.ONE * floori(s.x * 0.5)

	for i: int in range(steps):
		var pos: Vector2i = lerp(to, from, i / float(steps))
		var brect := Rect2i(Vector2i(pos) - pos_offset, s)
		target.blit_rect(brect, square_texture, color)

func on_end(target: DrawableTexture2D, pos: Vector2, size: int, color: Color):
		pass

func _get_size(size: int) -> Vector2i:
	return Vector2i.ONE * sizes[(clampi(size, 1, 9)-1)]
