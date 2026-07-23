extends Node2D

@onready var drawingButton: Button = %DrawingButton;
@onready var auctionButton: Button = %AuctionButton;
@onready var museumButton: Button = %MuseumButton;

func _ready() -> void:
	drawingButton.pressed.connect(func(): Global.gameCycle.goToLevelDrawing())
	auctionButton.pressed.connect(func(): Global.gameCycle.goToLevelAuction())
	museumButton.pressed.connect(func(): Global.gameCycle.goToLevelMuseum())
