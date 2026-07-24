class_name AuctionController
extends Node

var AUCTION_TIMEOUT = 5.0;

const RAISE_STEP_RATIOS: Array[float] = [0.1, 0.5, 1.0]

var currentPlayerPainting: PaintingData;
var currentOtherPlayerPainting: PaintingData;

var currentPlayerPaintingPrice: int = 0;
var currentPlayerRaiseStep: int = 0;

var paintingsForSold: Array[PaintingData];

func receivePaintingFromPlayer(painting: PaintingData):
	currentPlayerPainting = painting;
	currentPlayerPaintingPrice = painting.initialPrice;
	currentPlayerRaiseStep = 0;

func receivePaintingFromOtherPlayer(painting: PaintingData):
	currentOtherPlayerPainting = painting;

func hasRaisesRemaining() -> bool:
	return currentPlayerPainting != null and currentPlayerRaiseStep < RAISE_STEP_RATIOS.size()

func tryRaisePrice() -> int:
	if not hasRaisesRemaining():
		return -1
	var ratio: float = RAISE_STEP_RATIOS[currentPlayerRaiseStep]
	var raiseAmount: int = int(ceil(currentPlayerPainting.initialPrice * ratio))
	var candidatePrice: int = currentPlayerPaintingPrice + raiseAmount
	if candidatePrice > currentPlayerPainting.maxPrice:
		return -1
	currentPlayerPaintingPrice = candidatePrice
	currentPlayerRaiseStep += 1
	return currentPlayerPaintingPrice

func getRandomPaintingsForSold():
	var painting = paintingsForSold.pick_random();
	if(paintingsForSold.size() < 3):
		updatePaintingsFromOtherPlayers();
	return painting;

func getPaintingsFromServer():
	for i in range(8):
		var painting: PaintingData = Global.gameCycle.paintingController.createPainting(null);
		paintingsForSold.push_back(painting);

func updatePaintingsFromOtherPlayers():
	await getPaintingsFromServer()