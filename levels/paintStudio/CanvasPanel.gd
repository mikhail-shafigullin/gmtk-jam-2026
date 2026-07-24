class_name CanvasPanel
extends Panel

signal brush_start(brush: PaintBrush)
signal brush_stroke(brush: PaintBrush, length: float)
signal brush_end(brush: PaintBrush)

const pixel_texture := preload("res://levels/paintStudio/Brushes/textures/1x1.png")

@export var bg_color := Color.WHITE
@export var brush_color := Color.PINK
@export var brush_size: int = 5
var brush: PaintBrush = null

const IMG_SIZE := Vector2i(128, 128)
const IMG_FORMAT := DrawableTexture2D.DRAWABLE_FORMAT_RGBA8

var preview := DrawableTexture2D.new()
var canvas := DrawableTexture2D.new()

var preview_sprite := Sprite2D.new()
var canvas_sprite := Sprite2D.new()

var undo_position: int = 0
var undo_stack: Array[PackedByteArray] = []

var is_active: bool = false:
	set=set_is_active
var _is_painting: bool = false
var _paint_start_time: int
var _paint_current_length: float
var paint_strokes: Array[BrushStroke] = []
var paint_undo_count: int = 0


func _ready() -> void:
	_setup_sprites()
	_on_resized()

func set_is_active(status: bool) -> void:
	if status and not is_active:
		reset(true)

	is_active = status

	if not is_active and _is_painting:
		on_paint_end()
		preview.setup(IMG_SIZE.x, IMG_SIZE.y, IMG_FORMAT, Color.TRANSPARENT, false)


func get_image() -> Image:
	return canvas.get_image()


func _setup_sprites():
	#textures
	preview.setup(IMG_SIZE.x, IMG_SIZE.y, IMG_FORMAT, Color.TRANSPARENT, false)
	canvas.setup(IMG_SIZE.x, IMG_SIZE.y, IMG_FORMAT, bg_color, false)

	#sprites
	preview_sprite.name = "PreviewSprite"
	canvas_sprite.name = "CanvasSprite"
	preview_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	canvas_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(canvas_sprite, true)
	add_child(preview_sprite, true)
	preview_sprite.texture = preview
	canvas_sprite.texture = canvas

	reset(true)

	resized.connect(_on_resized)


func get_data() -> PaintingData:
	var data := PaintingData.new()
	data.texture = ImageTexture.create_from_image(get_image())
	data.undoCount = paint_undo_count
	data.paintLength = get_paint_length()
	data.paintStokes = get_paint_strokes_count()
	data.paintTime = get_total_paint_time()
	data.colorCount = get_unique_colors_count()
	data.brushesCount = get_unique_brushes_count()

	return data

func get_paint_length() -> float:
	var l: float = 0.0
	for s: BrushStroke in paint_strokes:
		l += s.length
	return l

func get_paint_strokes_count() -> int:
	return paint_strokes.size()

func get_total_paint_time() -> float:
	var t: float = 0.0
	for s: BrushStroke in paint_strokes:
		t += s.time
	return t

func get_unique_colors_count() -> int:
	var c: Dictionary[Color, int] = {}
	for s: BrushStroke in paint_strokes:
		c[s.color] = 1
	return c.keys().size()

func get_unique_brushes_count() -> int:
	var b: Dictionary[String, int] = {}
	for s: BrushStroke in paint_strokes:
		b[str(s.brush)+"-"+str(s.size)] = 1
	return b.keys().size()

func reset(hard: bool = false):
	undo_position = 0
	undo_stack.clear()
	canvas.setup(IMG_SIZE.x, IMG_SIZE.y, IMG_FORMAT, bg_color, false)
	undo_stack.push_back(get_canvas_data())

	if hard:
		paint_strokes.clear()
		paint_undo_count = 0


func _on_resized():
	if preview and canvas:
		preview_sprite.position = Vector2i(size * 0.5)
		preview_sprite.scale = (size / preview.get_size())
		canvas_sprite.transform = preview_sprite.transform


func on_paint_start() -> void:
	if not _is_painting:
		_is_painting = true

		var pos := Vector2i(_pos_to_texture(get_local_mouse_position()))
		brush.on_start(canvas, pos, brush_size, brush_color)
		brush_start.emit(brush)

		_paint_start_time = Time.get_ticks_msec() 
		_paint_current_length = 0


func on_paint_end() -> void:
	if _is_painting:
		_is_painting = false

		var pos := Vector2i(_pos_to_texture(get_local_mouse_position()))
		brush.on_end(canvas, pos, brush_size, brush_color)
		brush_end.emit(brush)
		commit()

		var stroke := BrushStroke.new()
		stroke.brush = brush
		stroke.color = brush_color
		stroke.size = brush_size
		stroke.length = _paint_current_length
		stroke.time = float(Time.get_ticks_msec() - _paint_start_time) / 1000.0
		paint_strokes.push_back(stroke)


func on_paint_stroke(length: float):
	var grect := get_global_rect()
	if grect.has_point(get_global_mouse_position()):
		_paint_current_length += length
	brush_stroke.emit(brush, length)


func _gui_input(event: InputEvent) -> void:
	if is_active:

		if event is InputEventMouseButton:
			if event.button_index == (MOUSE_BUTTON_LEFT):
				if event.pressed:
					on_paint_start()
				else:
					on_paint_end()
		
		elif event is InputEventMouseMotion:
			# print_debug(event.position, event.relative)
			if _is_painting and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				var to := Vector2i(_pos_to_texture(event.position))
				var from := Vector2i(_pos_to_texture(event.position - event.relative))
				brush.paint(canvas, from, to, brush_size, brush_color)
				on_paint_stroke(event.relative.length())

func _input(event: InputEvent) -> void:
	if is_active:

		if event.is_pressed():
			if event.is_action("paint_undo"):
				undo()
			elif event.is_action("paint_redo"):
				redo()


func _process(delta: float) -> void:
	if is_active:
		var mouse_pos := get_local_mouse_position()
		preview.setup(IMG_SIZE.x, IMG_SIZE.y, IMG_FORMAT, Color.TRANSPARENT, false)
		# preview.blit_rect(Rect2i(Vector2i.ZERO, IMG_SIZE), pixel_texture, Color.TRANSPARENT)
		var pos := Vector2i(_pos_to_texture(mouse_pos))
		brush.preview(preview, pos, brush_size, brush_color)

	# if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
	# 	preview_sprite.modulate.a = 1
	# else:
	# 	preview_sprite.modulate.a = 0.75



func _pos_to_texture(pos: Vector2) -> Vector2:
	return pos * (canvas.get_size() / size)


func get_canvas_data() -> PackedByteArray:
	var img := canvas.get_image()
	return img.get_data()

func set_canvas_data(new_data: PackedByteArray) -> void:
	canvas.setup(IMG_SIZE.x, IMG_SIZE.y, IMG_FORMAT, bg_color, false)

	var i := Image.create_from_data(IMG_SIZE.x, IMG_SIZE.y, false, Image.FORMAT_RGBA8, new_data)
	var t := ImageTexture.create_from_image(i)
	canvas.blit_rect(Rect2i(Vector2i.ZERO, IMG_SIZE), t)

func commit() -> void:
	if (undo_position < undo_stack.size() - 1):
		undo_stack.resize(undo_position + 1)

	undo_stack.push_back(get_canvas_data())
	undo_position += 1

func undo() -> void:
	if is_active:
		if undo_position > 0:
			paint_undo_count += 1

		undo_position = clampi(undo_position-1, 0, undo_stack.size()-1)
		set_canvas_data(undo_stack[undo_position])

func redo() -> void:
	if is_active:
		if undo_position < undo_stack.size()-1:
			paint_undo_count -= 1

		undo_position = clampi(undo_position+1, 0, undo_stack.size()-1)
		set_canvas_data(undo_stack[undo_position])

func _on_undo_button_pressed() -> void:
	undo()
	pass # Replace with function body.


func _on_redo_button_pressed() -> void:
	redo()
	pass # Replace with function body.


func _on_color_picker_button_color_changed(color: Color) -> void:
	brush_color = color


func _on_h_slider_value_changed(value: float) -> void:
	brush_size = int(value)


func _on_brush_selector_brush_selected(new_brush: PaintBrush) -> void:
	brush = new_brush


func _on_clear_button_pressed() -> void:
	if is_active:
		reset()


func _on_pallet_color_selected(color: Variant) -> void:
	brush_color = color
