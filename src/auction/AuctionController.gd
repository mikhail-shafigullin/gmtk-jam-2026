class_name AuctionController
extends Node

var currentPlayerPainting: PaintingData;
var currentOtherPlayerPainting: PaintingData;

func receivePaintingFromPlayer(painting: PaintingData):
	currentPlayerPainting = painting;