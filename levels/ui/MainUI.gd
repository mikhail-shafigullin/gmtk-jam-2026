extends Control

@onready var moneyValue: Label = %MoneyValue
@onready var fameValue: Label = %FameValue;

func _ready() -> void:
	moneyValue.text = str(Global.gameCycle.playerData.money);
	fameValue.text = str(Global.gameCycle.playerData.fame);
	EventBus.updateMoney.connect(updateMoney)
	EventBus.updateFame.connect(updateFame)
	pass;

func updateMoney(_money: int):
	moneyValue.text = str(Global.gameCycle.playerData.money)

func updateFame(_fame: int):
	fameValue.text = str(Global.gameCycle.playerData.fame)