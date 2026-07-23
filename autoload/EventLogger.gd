extends Node


func _ready() -> void:
	var bus := EventBus

	var baseSignals := {}
	for sig in ClassDB.class_get_signal_list("Node", false):
		baseSignals[sig["name"]] = true

	for sig in bus.get_signal_list():
		var sigName: String = sig["name"]
		if baseSignals.has(sigName):
			continue
		var argCount: int = sig["args"].size()
		var signalObject: Signal = bus[sigName]
		if argCount == 0:
			signalObject.connect(logEvent.bind(sigName))
		elif argCount == 1:
			signalObject.connect(logEventWithArg.bind(sigName))
		elif argCount == 2:
			signalObject.connect(logEventWithTwoArgs.bind(sigName))
		else:
			pass;


func logEvent(eventName: String) -> void:
	print("[EventLogger] %s" % eventName)

func logEventWithArg(_arg: Variant, eventName: String) -> void:
	print("[EventLogger] %s" % eventName)

func logEventWithTwoArgs(_arg1: Variant, _arg2: Variant, eventName: String) -> void:
	print("[EventLogger] %s" % eventName)
