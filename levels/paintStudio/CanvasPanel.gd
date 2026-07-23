extends Panel

signal brush_start(brush: PaintBrush)
signal brush_stroke(brush: PaintBrush)
signal brush_end(brush: PaintBrush)

@export var bg_color := Color.BLACK
@export var brush_color := Color.PINK
@export var brush_size: int = 5
var brush: PaintBrush = SquareBrush.new()

const IMG_SIZE := Vector2i(128, 128)
const IMG_FORMAT := DrawableTexture2D.DRAWABLE_FORMAT_RGBA8

var preview := DrawableTexture2D.new()
var canvas := DrawableTexture2D.new()

var preview_sprite := Sprite2D.new()
var canvas_sprite := Sprite2D.new()

var undo_position: int = 0
var undo_stack: Array[PackedByteArray] = []



func _ready() -> void:
	_setup_sprites()
	_on_resized()



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

	undo_position = 0
	undo_stack.push_back(get_canvas_data())

	resized.connect(_on_resized)


func _on_resized():
	if preview and canvas:
		preview_sprite.position = Vector2i(size * 0.5)
		preview_sprite.scale = (size / preview.get_size())
		canvas_sprite.transform = preview_sprite.transform


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == (MOUSE_BUTTON_LEFT):
			var pos := Vector2i(_pos_to_texture(event.position))
			if event.pressed:
				brush.on_start(canvas, pos, brush_size, brush_color)
				brush_start.emit(brush)
			else:
				brush.on_end(canvas, pos, brush_size, brush_color)
				brush_end.emit(brush)
				commit()
	
	elif event is InputEventMouseMotion:
		# print_debug(event.position, event.relative)
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			var to := Vector2i(_pos_to_texture(event.position))
			var from := Vector2i(_pos_to_texture(event.position - event.relative))
			brush.paint(canvas, from, to, brush_size, brush_color)
			brush_stroke.emit(brush)

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if event.is_action("paint_undo"):
			undo()
		elif event.is_action("paint_redo"):
			redo()


func _process(delta: float) -> void:
	var mouse_pos := get_local_mouse_position()
	preview.setup(IMG_SIZE.x, IMG_SIZE.y, IMG_FORMAT, Color.TRANSPARENT, false)
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var pos := Vector2i(_pos_to_texture(mouse_pos))
		brush.preview(preview, pos, brush_size, brush_color)

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
	undo_position = clampi(undo_position-1, 0, undo_stack.size()-1)
	set_canvas_data(undo_stack[undo_position])

func redo() -> void:
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
