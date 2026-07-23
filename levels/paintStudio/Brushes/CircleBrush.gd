class_name CircleBrush
extends PaintBrush

const circle1 := preload("res://levels/paintStudio/Brushes/textures/1x1.png")
const circle3 := preload("res://levels/paintStudio/Brushes/textures/circles/3x3_circle.png")
const circle5 := preload("res://levels/paintStudio/Brushes/textures/circles/5x5_circle.png")
const circle7 := preload("res://levels/paintStudio/Brushes/textures/circles/7x7_circle.png")
const circle9 := preload("res://levels/paintStudio/Brushes/textures/circles/9x9_circle.png")
const circle11 :=preload("res://levels/paintStudio/Brushes/textures/circles/11x11_circle.png")
const circle13 :=preload("res://levels/paintStudio/Brushes/textures/circles/13x13_circle.png")
const circle15 :=preload("res://levels/paintStudio/Brushes/textures/circles/15x15_circle.png")
const circle17 :=preload("res://levels/paintStudio/Brushes/textures/circles/17x17_circle.png")
const circles: Array[Texture] = [
	circle1,
	circle3,
	circle5,
	circle7,
	circle9,
	circle11,
	circle13,
	circle15,
	circle17
]


func preview(target: DrawableTexture2D, pos: Vector2, size: int,  color: Color):
	var t := _get_texture(size)
	var s := Vector2i(t.get_size().floor())
	var pos_offset := Vector2i.ONE * floori(s.x * 0.5)
	var brect := Rect2i(Vector2i(pos) - pos_offset, s)
	target.blit_rect(brect, t, color)

func on_start(target: DrawableTexture2D, pos: Vector2, size: int, color: Color):
	var t := _get_texture(size)
	var s := Vector2i(t.get_size())
	var pos_offset := Vector2i.ONE * floori(s.x * 0.5)
	var brect := Rect2i(Vector2i(pos) - pos_offset, s)
	target.blit_rect(brect, t, color)

func paint(target: DrawableTexture2D, from: Vector2, to: Vector2, size: int, color: Color):
	var steps: int = max((from - to).length(), 1)
	var t := _get_texture(size)
	var s := Vector2i(t.get_size())
	var pos_offset := Vector2i.ONE * floori(s.x * 0.5)
	for i: int in range(steps):
		var pos: Vector2i = lerp(to, from, i / float(steps))
		var brect := Rect2i(Vector2i(pos) - pos_offset, s)
		target.blit_rect(brect, t, color)

func on_end(target: DrawableTexture2D, pos: Vector2, size: int, color: Color):
		pass


func _get_texture(size: int) -> Texture2D:
	return circles[(clampi(size, 1, 9)-1)]
