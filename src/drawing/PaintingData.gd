class_name PaintingData
extends Resource

enum {
	S_BRUSHES,
	S_COLORS,
	S_TIME,
	S_STROKES,
	S_LENGTH,
	S_UNDOS,
	S_INIT_FAME,
	S_INIT_PRICE,
	S_MAX_PRICE,
	S_TITLE
}


@export var texture: Texture2D;
@export var title: String;
@export var brushesCount: int;
@export var colorCount: int;
@export var paintTime: float;
@export var paintStokes: int;
@export var paintLength: int;
@export var undoCount: int;
@export var initialFame: int;
@export var initialPrice: int;
@export var maxPrice: int;


func serialize_stats() -> String:
	return JSON.stringify({
		S_TITLE : title.left(64),
		S_BRUSHES : brushesCount,
		S_COLORS : colorCount,
		S_TIME : paintTime,
		S_STROKES : paintStokes,
		S_LENGTH : paintLength,
		S_UNDOS : undoCount,
		S_INIT_FAME : initialFame,
		S_INIT_PRICE : initialPrice,
		S_MAX_PRICE : maxPrice,
	})


func deserialize_stats(from: String) -> Error:
	var dict: Dictionary = JSON.parse_string(from)
	if not dict:
		return Error.ERR_FILE_CORRUPT
	
	title = dict.get_or_add(str(S_TITLE), "UNNAMED PAINTING")
	brushesCount = dict.get_or_add(str(S_BRUSHES), 0)
	colorCount = dict.get_or_add(str(S_COLORS), 0)
	paintTime = dict.get_or_add(str(S_TIME), 0.0)
	paintStokes = dict.get_or_add(str(S_STROKES), 0)
	paintLength = dict.get_or_add(str(S_LENGTH), 0)
	undoCount = dict.get_or_add(str(S_UNDOS), 0)
	initialFame = dict.get_or_add(str(S_INIT_FAME), 0)
	initialPrice = dict.get_or_add(str(S_INIT_PRICE), 0)
	maxPrice = dict.get_or_add(str(S_MAX_PRICE), 0)
	return Error.OK


func _to_string() -> String:
	return (
		"""
	title: %s,
	texture: %s,
	unique colors: %s,
	unique brushes: %s,
	undo count: %s,
	painting strokes: %s,
	painting time: %s,
	painting length: %s,
	initial fame: %s,
	initial price: %s,
	max price: %s
		"""%[title, str(texture), colorCount, brushesCount, undoCount,
		paintStokes, paintTime, paintLength, initialFame, initialPrice, maxPrice]
	)
