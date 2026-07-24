class_name PaintingSlot
extends Area2D

signal clicked

@onready var pol: Polygon2D = $Texture
@onready var collision: CollisionPolygon2D = $Collision
@onready var timer: Timer = $PayoutTimer

const info_label_res = preload("res://levels/museum/InfoParticle.tscn")

var painting: PaintingData = null:
	set(p):
		painting = p
		if painting:
			pol.color = Color.WHITE
			pol.texture = painting.texture
		else:
			pol.color = Color.GRAY
			pol.texture = null

var focused: bool = false:
	set(v):
		focused = v
		modulate = Color(1.1, 1.1, 1.1, 1) if focused else Color.WHITE;
	
var _center := Vector2.ZERO

func _ready() -> void:
	collision.polygon = pol.polygon
	painting = null
	
	input_event.connect(on_input)
	mouse_entered.connect(func(): focused = true)
	mouse_exited.connect(func(): focused = false)

	timer.timeout.connect(on_payout_timer)
	timer.start(randf() * 1.5)
	
	calc_center_offset()
	
func on_payout_timer() -> void:
	timer.start(randf_range(0.5, 2.5))
	pay_money(randi_range(10, 150))

func pay_money(sum: int):
	Global.gameCycle.updateMoney(sum);
	pop_info("$%s"%sum)

func pop_info(info: Variant):
	var ip: Node2D = info_label_res.instantiate()
	ip.text = str(info)
	add_child(ip)
	var rand_offset := Vector2(randf() - 0.5, randf() - 0.5) * 50
	ip.global_position = pol.global_position + _center + rand_offset

func calc_center_offset() -> void:
	var sum := Vector2.ZERO
	for c: Vector2 in pol.polygon:
		sum += c
	_center = sum / pol.polygon.size()


func on_input(_vp: Viewport, event: InputEvent, _shape: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			clicked.emit()
