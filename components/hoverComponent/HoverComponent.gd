class_name HoverComponent
extends Node

signal hovered()
signal unhovered()

var _isHovered: bool = false


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var parent := get_parent() as Node2D
		if parent != null:
			_updateHoverState(parent)


func _updateHoverState(parent: Node2D) -> void:
	var body := _findStaticBody(parent)
	if body == null:
		return

	var mousePos := parent.get_global_mouse_position()
	var spaceState := parent.get_world_2d().direct_space_state
	var query := PhysicsPointQueryParameters2D.new()
	query.position = mousePos
	query.collide_with_bodies = true

	var nowHovered := false
	for result in spaceState.intersect_point(query):
		if result["collider"] == body:
			nowHovered = true
			break

	if nowHovered and not _isHovered:
		_isHovered = true
		hovered.emit()
	elif not nowHovered and _isHovered:
		_isHovered = false
		unhovered.emit()


func _findStaticBody(node: Node) -> StaticBody2D:
	for child in node.get_children():
		if child is StaticBody2D:
			return child as StaticBody2D
	return null
