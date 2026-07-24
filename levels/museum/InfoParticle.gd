extends Node2D

var init_lifetime: float = 0.5
var speed = 60

var text: String:
	set(t):
		text = t
		$Label.text = t


var lifetime := init_lifetime
var _fade_rate := (1 / init_lifetime)


func _process(delta: float) -> void:
	position += Vector2((randf()-0.5), -randf()) * delta * speed
	lifetime -= delta
	if lifetime < 0:
		queue_free()
