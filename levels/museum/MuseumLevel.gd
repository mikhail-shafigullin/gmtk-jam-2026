extends Node2D

@onready var studioButton: Button = %StudioButton;

func _ready() -> void:
	studioButton.pressed.connect(func(): Global.gameCycle.goToLevelHub())
