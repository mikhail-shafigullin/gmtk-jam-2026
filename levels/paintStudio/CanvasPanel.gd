extends Panel

@export var bg_color := Color.BLACK
@export var brush_color := Color.PINK
@export var brush_size := Vector2i(8, 8)

const IMG_SIZE := Vector2i(128, 128)
const IMG_FORMAT := DrawableTexture2D.DRAWABLE_FORMAT_RGBA8

var stroke_stack: Array[PaintStroke]

var preview: DrawableTexture2D
var canvas: DrawableTexture2D

var preview_sprite: Sprite2D
var canvas_sprite: Sprite2D

func _ready() -> void:
	_setup_sprites()
	_on_resized()

	pass

func _setup_sprites():
	#textures
	preview = DrawableTexture2D.new()
	preview.setup(IMG_SIZE.x, IMG_SIZE.y, IMG_FORMAT, Color.TRANSPARENT, false)
	canvas = DrawableTexture2D.new()
	canvas.setup(IMG_SIZE.x, IMG_SIZE.y, IMG_FORMAT, bg_color, false)

	#sprites
	preview_sprite = Sprite2D.new()
	canvas_sprite = Sprite2D.new()
	preview_sprite.name = "PreviewSprite"
	canvas_sprite.name = "CanvasSprite"
	preview_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	canvas_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(canvas_sprite, true)
	add_child(preview_sprite, true)
	preview_sprite.texture = preview
	canvas_sprite.texture = canvas

	resized.connect(_on_resized)

func _on_resized():
	if preview and canvas:
		preview_sprite.position = Vector2i(size * 0.5)
		preview_sprite.scale = (size / preview.get_size())
		canvas_sprite.transform = preview_sprite.transform


var debug_circle: Texture = preload("uid://dvyip3m7d6tnx")
var debug_brush := PaintBrush.new()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == (MOUSE_BUTTON_LEFT):
			var pos := Vector2i(_pos_to_texture(event.position))
			if event.pressed:
				debug_brush.on_start(canvas, pos, brush_size, brush_color)
			else:
				debug_brush.on_end(canvas, pos, brush_size, brush_color)

	elif event is InputEventMouseMotion:
		print_debug(event.position, event.relative)
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			var to := Vector2i(_pos_to_texture(event.position))
			var from := Vector2i(_pos_to_texture(event.position - event.relative))
			debug_brush.paint(canvas, from, to, brush_size, brush_color)


func _process(delta: float) -> void:
	var mouse_pos := get_local_mouse_position()
	preview.setup(IMG_SIZE.x, IMG_SIZE.y, IMG_FORMAT, Color.TRANSPARENT, false)
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var pos := Vector2i(_pos_to_texture(mouse_pos))
		debug_brush.preview(preview, pos, brush_size, brush_color)

func _pos_to_texture(pos: Vector2) -> Vector2:
	return pos * (canvas.get_size() / size)
