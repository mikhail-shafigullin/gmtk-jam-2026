extends Node

var gameAnalytics;

func _ready():
	if(Engine.has_singleton("GameAnalytics")):
		gameAnalytics = Engine.get_singleton("GameAnalytics")
		gameAnalytics.init(AnalyticsSecrets.GAME_KEY, AnalyticsSecrets.SECRET_KEY)
		gameAnalytics.setEnabledInfoLog(true);

func sendDebugRequest(number: int):
	var optArgs = {
		"eventNumber": number,
		"eventVar": self
	}
	gameAnalytics.addDesignEvent("my:design:event", optArgs)

func sendProgressionEvent(number: int):
	var optArgs = {
		"eventNumber": number
	}
	gameAnalytics.addProgressionEvent("start", "act" + str(number), "", "", optArgs)