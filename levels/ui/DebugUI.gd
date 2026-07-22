class_name DebugUI
extends Control

const HUB_LEVEL_PATH = "res://levels/HubLevel.tscn"
const DRAWING_LEVEL_PATH = "res://levels/DrawingLevel.tscn"
const MUSEUM_LEVEL_PATH = "res://levels/MuseumLevel.tscn"
const AUCTION_LEVEL_PATH = "res://levels/AuctionLevel.tscn"

@onready var hubButton: Button = %HubButton
@onready var drawingButton: Button = %DrawingButton
@onready var museumButton: Button = %MuseumButton
@onready var auctionButton: Button = %AuctionButton

func _ready() -> void:
	hubButton.pressed.connect(func(): Global.gameCycle.goToLevelHub())
	drawingButton.pressed.connect(func(): Global.gameCycle.goToLevelDrawing())
	museumButton.pressed.connect(func(): Global.gameCycle.goToLevelMuseum())
	auctionButton.pressed.connect(func(): Global.gameCycle.goToLevelAuction())
