extends Node2D

func _on_button_pressed():
	Analytics.sendProgressionEvent(1)


func _on_button_2_pressed() -> void:
	Analytics.sendProgressionEvent(2)
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	Analytics.sendProgressionEvent(3)
	pass # Replace with function body.
