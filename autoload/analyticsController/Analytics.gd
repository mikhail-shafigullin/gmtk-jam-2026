extends Node

var gameAnalytics;

func _ready():
	if( Engine.has_singleton("GameAnalytics")):
		gameAnalytics = Engine.get_singleton("GameAnalytics")
		gameAnalytics.setEnabledInfoLog(true);
		
		if (Engine.has_singleton("AnalyticsSecrets")):
			var sicrets = Engine.get_singleton("AnalyticsSecrets")
			gameAnalytics.init(sicrets.GAME_KEY, sicrets.SECRET_KEY)


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
