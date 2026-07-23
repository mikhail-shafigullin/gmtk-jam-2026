class_name GameCycleController
extends Node

var playerData: PlayerData;
var locationController: LocationController;
var paintingController: PaintingController;
var auctionController: AuctionController;
var museumController: MuseumController;

func _init() -> void:
	locationController = LocationController.new();
	paintingController = PaintingController.new();
	museumController = MuseumController.new();
	auctionController = AuctionController.new();
	startGame();
	pass;

func startGame():
	playerData = PlayerData.new();
	playerData.playerName = "PoopPlayer"
	playerData.money = 0
	playerData.fame = 0

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

func sendDrawing(texture: Texture2D):
	var painting = paintingController.createPainting(texture);
	auctionController.receivePaintingFromPlayer(painting);
	EventBus.drawing_sent.emit(painting);

func receiveDrawingFromOtherPlayer():
	EventBus.drawing_received_from_other_player.emit();

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
