class_name SprayBrush
extends PaintBrush


var _spray_rng: int = 0

const circle1 := preload("res://levels/paintStudio/Brushes/textures/1x1.png")
const circle3 := preload("res://levels/paintStudio/Brushes/textures/circles/3x3_circle.png")
const circle5 := preload("res://levels/paintStudio/Brushes/textures/circles/5x5_circle.png")
const shapes :Array[Texture] = [circle1, circle3, circle5]
const spread :Array[int] = [3, 5, 10, 12, 13, 14,  15, 17, 22]
const dots :Array[int] = [1, 2, 2, 3, 3, 3, 4, 5, 6]

func preview(target: DrawableTexture2D, pos: Vector2, size: int,  color: Color):
	bilt_spray(target, pos, size, color)

func on_start(target: DrawableTexture2D, pos: Vector2, size: int, color: Color):
	bilt_spray(target, pos, size, color)
	_spray_rng = randi()

func paint(target: DrawableTexture2D, _from: Vector2, to: Vector2, size: int, color: Color):
	bilt_spray(target, to, size, color)
	_spray_rng = randi()


func bilt_spray(target: DrawableTexture2D, pos: Vector2, size: int,  color: Color):
	var iterations := dots[clampi(size-1, 0, 8)]
	var half_spread := spread[clampi(size-1, 0, 8)]
	var full_spread := half_spread * 2


	for i: int in range(iterations):
		var rand_right: int = rand_from_seed(_spray_rng + i)[0]
		var rand_left: int = rand_right >> 16
		
		var t := _get_texture(i + _spray_rng, size)
		var s := Vector2i(t.get_size().floor())
		var pos_offset := Vector2i.ONE * floori(s.x * 0.5)
		var random_pos_offset := Vector2i(rand_left%full_spread - half_spread, rand_right%full_spread - half_spread)
		var dot_pos := Vector2i(pos) + random_pos_offset
		var brect := Rect2i(dot_pos - pos_offset, s)
		target.blit_rect(brect, t, _get_color(color, rand_right, size))

func _get_color(color:Color, _rn: int, _size: int) -> Color:
	return color

func _get_texture(rn: int, size: int) -> Texture2D:
	if size < 3:
		return shapes[rand_from_seed(rn)[0]%3]
	else:
		return shapes[rand_from_seed(rn)[0]%2]
