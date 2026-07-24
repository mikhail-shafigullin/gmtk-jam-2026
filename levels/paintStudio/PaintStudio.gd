class_name PaintStudio
extends Control

@onready var canvas: CanvasPanel = $CanvasPanel
@onready var pallet: PaintingPallet = $Pallet


func _ready() -> void:
	EventBus.drawing_started.connect(start_painting)
	EventBus.drawing_finished.connect(end_painting)
	EventBus.drawing_time_limit_finished.connect(end_painting)


func start_painting() -> void:
	canvas.is_active = true


func end_painting() -> void:
	canvas.is_active = false


func get_texture() -> DrawableTexture2D:
	return canvas.canvas


func save() -> void:
	var data := canvas.get_data()
	#var buff := PaintingLoader.serialize_painting(data)
	#PaintingLoader.write_temp_file(buff)
	PaintingLoader.write_temp_file_res(data)

func _on_save_button_pressed() -> void:
	save()

func _on_canvas_panel_painting_started() -> void:
	for b: Button in pallet.buttons:
		var col: Color = b.modulate
		if col != canvas.bg_color:
			pallet.select_btn(b)
			break
