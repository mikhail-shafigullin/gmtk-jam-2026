class_name GameCycleController
extends Node

var playerData: PlayerData;
var locationController: LocationController;
var drawingController: DrawingController;
var museumController: MuseumController;

func _init() -> void:
	locationController = LocationController.new();
	drawingController = DrawingController.new();
	museumController = MuseumController.new();
	pass;

func startGame():
	playerData = PlayerData.new();
	goToLevelDrawing();

func goToLevelDrawing():
	locationController.changeLevel(LocationController.Location.DRAWING);

func goToLevelHub():
	locationController.changeLevel(LocationController.Location.HUB);

func goToLevelAuction():
	locationController.changeLevel(LocationController.Location.AUCTION);

func goToLevelMuseum():
	locationController.changeLevel(LocationController.Location.MUSEUM);

func startDrawing():
	EventBus.drawing_started.emit();

func finishDrawingTimeLimit():
	EventBus.drawing_time_limit_finished.emit();

func finishDrawing():
	EventBus.drawing_finished.emit();

func sendDrawing():
	EventBus.drawing_sent.emit();

func receiveDrawing():
	EventBus.drawing_received.emit();

func bidAuctionSomeone():
	EventBus.auction_someone_bid.emit();

func sellAuctionPainting():
	EventBus.auction_painting_sold.emit();

func bidAuctionUser():
	EventBus.auction_user_bid.emit();

func buyAuctionPainting():
	EventBus.auction_painting_bought.emit();

func putMuseumPainting():
	EventBus.museum_painting_put.emit();

func addMuseumPaintingMoney():
	EventBus.museum_painting_add_money.emit();

func sellMuseumPainting():
	EventBus.museum_painting_sold.emit();

