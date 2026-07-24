extends Control

signal color_selected(color)

const pallet_button_res := preload("res://levels/paintStudio/PalletButton.tscn")

@onready var grid: GridContainer = $GridContainer

var buttons: Array[Button] = []

var colors: Array[Color] = [
	Color.WHITE,
	Color.GRAY,
	Color.DIM_GRAY,
	Color.BLACK,
	Color.RED,
	Color.DARK_RED,
	Color.BLUE,
	Color.DARK_BLUE,
	Color.GREEN,
	Color.DARK_GREEN,
	Color.AQUA
]

func _clear_buttons() -> void:
	buttons.clear()
	for c: Node in grid.get_children():
		c.queue_free()

func _create_buttons() -> void:
	_clear_buttons()
	grid.columns = int(colors.size() / 2)
	for c: Color in colors:
		var button: Button = pallet_button_res.instantiate()
		button.pressed.connect(on_button_press.bind(button))
		button.modulate = c
		grid.add_child(button)

		buttons.push_back(button)

func _ready() -> void:
	_create_buttons()


func on_button_press(btn: Button):
	for b: Button in buttons:
		b.button_pressed = false
	btn.button_pressed = true

	color_selected.emit(btn.modulate)
	
