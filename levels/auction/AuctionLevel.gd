extends Node2D

@onready var studioButton: Button = %StudioButton;
@onready var paintingNameLabel: Label = %PaintingNameLabel;
@onready var timerLabel: Label = %TimerLabel;
@onready var currentCostLabel: Label = %CurrentCostLabel;
@onready var currentUserAuction: Control = %CurrentUserAuction;
@onready var anotherUserAuction: Control = %AnotherUserAuction;
@onready var sellPaintingButton: Button = %SellPaintingButton;
@onready var auctionTimer: Timer = %AuctionTimer;

var isPaintingTaken = true;
var isPaintingSold = false;

func _ready() -> void:
	studioButton.pressed.connect(func(): Global.gameCycle.goToLevelHub())
	sellPaintingButton.pressed.connect(onSellPaintingButtonPressed)
	EventBus.drawing_sent.connect(onDrawingSent)
	EventBus.drawing_received_from_other_player.connect(onDrawingReceivedFromOtherPlayer)
	EventBus.auction_someone_bid.connect(onAuctionSomeoneBid)
	EventBus.level_changed.connect(onChangeLevel)
	auctionTimer.timeout.connect(onAuctionTimerTimeout)
	auctionTimer.wait_time = Global.gameCycle.auctionController.AUCTION_TIMEOUT;
	initializeFromCurrentPaintings()
	tryStartTimer();
	

func _process(_delta: float) -> void:
	updateTimerLabel()

func initializeFromCurrentPaintings() -> void:
	var auctionController = Global.gameCycle.auctionController
	var playerPainting = auctionController.currentPlayerPainting
	var otherPlayerPainting = auctionController.currentOtherPlayerPainting

	if playerPainting != null and playerPainting.title != "":
		paintingNameLabel.text = playerPainting.title
		currentCostLabel.text = str(playerPainting.initialPrice)
		currentUserAuction.visible = true
		anotherUserAuction.visible = false
		isPaintingTaken = false;
	elif otherPlayerPainting != null and otherPlayerPainting.title != "":
		paintingNameLabel.text = otherPlayerPainting.title
		currentCostLabel.text = str(otherPlayerPainting.initialPrice)
		currentUserAuction.visible = false
		anotherUserAuction.visible = true
		isPaintingTaken = false;
	else:
		paintingNameLabel.text = "<empty>"
		currentUserAuction.visible = false
		anotherUserAuction.visible = false
		isPaintingTaken = true;

func onDrawingSent(painting: PaintingData) -> void:
	paintingNameLabel.text = painting.title if painting.title != "" else "<empty>"
	currentCostLabel.text = str(painting.maxPrice)
	currentUserAuction.visible = true
	anotherUserAuction.visible = false
	isPaintingTaken = false;

func onDrawingReceivedFromOtherPlayer() -> void:
	currentUserAuction.visible = false
	anotherUserAuction.visible = true
	isPaintingTaken = false;

func onAuctionSomeoneBid(cost: int) -> void:
	currentCostLabel.text = str(cost)

func onChangeLevel(location: LocationController.Location) -> void:
	if location == LocationController.Location.AUCTION:
		tryStartTimer()

func tryStartTimer():
	if !isPaintingTaken:
		isPaintingSold = false;
		auctionTimer.start()

func updateTimerLabel() -> void:
	if(isPaintingSold):
		return
	if(isPaintingTaken):
		timerLabel.text = "Waiting for the next auction lot"
		return
	var timeLeft = auctionTimer.time_left
	var cost = currentCostLabel.text
	if timeLeft < 1.5:
		timerLabel.text = cost + " Three!!"
	elif timeLeft < 3:
		timerLabel.text = cost + " Two!"
	elif timeLeft < 4.5:
		timerLabel.text = cost + " One!"
	else:
		timerLabel.text = "";

func onAuctionTimerTimeout() -> void:
	isPaintingSold = true
	timerLabel.text = "Sold!!!"

func onSellPaintingButtonPressed() -> void:
	Global.gameCycle.sellAuctionPainting(int(currentCostLabel.text))
	currentCostLabel.text = "";
	currentUserAuction.visible = false
	isPaintingTaken = true;
	isPaintingSold = false;
