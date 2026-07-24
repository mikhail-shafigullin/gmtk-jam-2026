extends Node2D

@onready var studioButton: Button = %StudioButton;
@onready var slots_container: Node2D = %PaintingsSlots
@onready var slots: Array[PaintingSlot] = []

func _ready() -> void:
	studioButton.pressed.connect(func(): Global.gameCycle.goToLevelHub())
	for c: Node in slots_container.get_children():
		if c is PaintingSlot:
			slots.push_back(c)
			c.clicked.connect(on_slot_clicked.bind(c))

func on_slot_clicked(slot: PaintingSlot):
	print_debug("slot[%s] clicked on"%[slots.find(slot)])
	slot.painting = PaintingLoader.read_random_file_res()
