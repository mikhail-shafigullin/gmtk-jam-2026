class_name PaintStudio
extends Control

var enabled
@onready var canvas: CanvasPanel = $CanvasPanel

func _process(_delta: float) -> void:
	var data := canvas.get_data()
	$test.text = str(data)

func _ready() -> void:
	EventBus.drawing_started.connect(start_painting)
	EventBus.drawing_finished.connect(end_painting)
	EventBus.drawing_time_limit_finished.connect(end_painting)

func start_painting() -> void:
	canvas.is_active = true

func end_painting() -> void:
	canvas.is_active = false

func save() -> void:
	var data := canvas.get_data()
	var buff := PaintingLoader.serialize_painting(data)
	PaintingLoader.write_temp_file(buff)


func _on_save_button_pressed() -> void:
	save()
