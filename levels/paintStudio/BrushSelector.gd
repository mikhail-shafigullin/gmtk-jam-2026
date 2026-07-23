extends Control

signal brush_selected(brush: PaintBrush)

var brushes: Dictionary[String, PaintBrush] = {
	"circle" : CircleBrush.new(),
	"square" : SquareBrush.new(),
	"spray"	: SprayBrush.new(),
	"line" : LineBrush.new()
}

@onready var circle_button = $CircleBrushButton
@onready var square_button = $SquareBrushButton
@onready var line_button = $LineBrushButton
@onready var spray_button = $SprayCanBrushButton

var busy: bool = false
func select_brush(name: String):
	for b: Button in get_children():
		b.button_pressed = false
	match name:
		"circle":
			circle_button.button_pressed = true
			brush_selected.emit(brushes[name])
		"square":
			square_button.button_pressed = true
			brush_selected.emit(brushes[name])
		"line":
			line_button.button_pressed = true
			brush_selected.emit(brushes[name])
		"spray":
			spray_button.button_pressed = true
			brush_selected.emit(brushes[name])

func _on_square_brush_button_pressed() -> void:
	select_brush("square")


func _on_circle_brush_button_pressed() -> void:
	select_brush("circle")


func _on_spray_can_brush_button_pressed() -> void:
	select_brush("spray")


func _on_line_brush_button_pressed() -> void:
	select_brush("line")
