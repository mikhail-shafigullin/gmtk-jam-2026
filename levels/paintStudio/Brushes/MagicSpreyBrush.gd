class_name MagicSprayBrush
extends SprayBrush


func _get_color(color:Color, _rn: int, _size: int) -> Color:
	var new_color = color
	var h_offset: int = _rn % 10
	var v_offset: int = (_rn >> 6) % 10
	# var a_offset: int = (_rn >> 12) % 10

	if _size >= 8:
		new_color.h = wrapf(1 + new_color.h + ((h_offset - 5) * 0.1), 0, 1)
		new_color.v = clampf(new_color.v + (v_offset - 5) * 0.04, 0, 1)
	elif _size > 3:
		new_color.h = wrapf(1 + new_color.h + (h_offset - 5) * 0.02, 0, 1)
		new_color.v = clampf(new_color.v + (v_offset - 5) * 0.015, 0, 1)
	else:
		new_color.h = wrapf(1 + new_color.h + (h_offset - 5) * 0.0125, 0, 1)
		new_color.v = clampf(new_color.v + (v_offset - 5) * 0.005, 0, 1)

	# new_color.a = clampf(new_color.a - (a_offset) * 0.09, 0, 1)
	return new_color
