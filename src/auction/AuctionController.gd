class_name AuctionController
extends Node

var AUCTION_TIMEOUT = 5.0;

var currentPlayerPainting: PaintingData;
var currentOtherPlayerPainting: PaintingData;

var paintingsForSold: Array[PaintingData];

func receivePaintingFromPlayer(painting: PaintingData):
	currentPlayerPainting = painting;

func receivePaintingFromOtherPlayer(painting: PaintingData):
	currentOtherPlayerPainting = painting;

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