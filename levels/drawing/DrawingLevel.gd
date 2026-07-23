extends Node2D

@onready var studioButton: Button = %StudioButton;
@onready var startPaintingButton: Button = %StartPaintingButton;
@onready var finishPaintingButton: Button = %FinishPaintingButton;
@onready var sendPaintingButton: Button = %SendPaintingButton;
@onready var paintingTimer: Timer = %PaintingTimer;
@onready var timerLabel: Label = %TimerLabel;
@onready var paintingIsReadyLabel: Label = %PaintingIsReadyLabel;

var isDrawingFinished: bool = false;

func _ready() -> void:
	studioButton.pressed.connect(func(): Global.gameCycle.goToLevelHub())
	startPaintingButton.pressed.connect(onStartPaintingButtonPressed)
	finishPaintingButton.pressed.connect(onFinishPaintingButtonPressed)
	sendPaintingButton.pressed.connect(onSendPaintingButtonPressed)
	paintingTimer.timeout.connect(onPaintingTimerTimeout)
	finishPaintingButton.disabled = true
	sendPaintingButton.disabled = true
	updatePaintingIsReadyLabel()

func _process(_delta: float) -> void:
	updateTimerLabel()

func onStartPaintingButtonPressed() -> void:
	startPaintingButton.disabled = true
	finishPaintingButton.disabled = false
	paintingTimer.start()
	Global.gameCycle.startDrawing()

func onFinishPaintingButtonPressed() -> void:
	sendPaintingButton.disabled = false
	finishPaintingButton.disabled = true
	paintingTimer.stop()
	isDrawingFinished = true
	updatePaintingIsReadyLabel()
	Global.gameCycle.finishDrawing()
		
func onSendPaintingButtonPressed() -> void:
	startPaintingButton.disabled = false
	sendPaintingButton.disabled = true
	isDrawingFinished = false
	updatePaintingIsReadyLabel()
	Global.gameCycle.sendDrawing(null)

func onPaintingTimerTimeout() -> void:
	sendPaintingButton.disabled = false
	finishPaintingButton.disabled = true
	Global.gameCycle.finishDrawingTimeLimit()
	isDrawingFinished = true
	updatePaintingIsReadyLabel()

func updateTimerLabel() -> void:
	var timeLeft := paintingTimer.time_left
	var seconds := int(timeLeft)
	var milliseconds := int((timeLeft - seconds) * 1000)
	timerLabel.text = "%02d:%03d" % [seconds, milliseconds]

func updatePaintingIsReadyLabel() -> void:
	paintingIsReadyLabel.text = "Ready" if isDrawingFinished else "Not Ready"
