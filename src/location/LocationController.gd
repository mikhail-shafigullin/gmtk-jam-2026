class_name LocationController
extends Node

const HUB_LEVEL_PATH = "res://levels/hub/HubLevel.tscn"
const DRAWING_LEVEL_PATH = "res://levels/drawing/DrawingLevel.tscn"
const MUSEUM_LEVEL_PATH = "res://levels/museum/MuseumLevel.tscn"
const AUCTION_LEVEL_PATH = "res://levels/auction/AuctionLevel.tscn"

enum Location{ HUB, DRAWING, AUCTION, MUSEUM }

func changeLevel(location: Location):	
	match location:
		Location.HUB:
			SceneTransitionManager.transitionToScene(HUB_LEVEL_PATH);
		Location.DRAWING:
			SceneTransitionManager.transitionToScene(DRAWING_LEVEL_PATH);
		Location.MUSEUM:
			SceneTransitionManager.transitionToScene(MUSEUM_LEVEL_PATH);
		Location.AUCTION:
			SceneTransitionManager.transitionToScene(AUCTION_LEVEL_PATH);
	EventBus.change_level.emit(location);