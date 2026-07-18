class_name GrabableMagnetComponent
extends Area2D

signal item_placed(node: Node2D)
signal item_removed(node: Node2D)
signal item_unhovered(node: Node2D)

## Called once when a dragged item's mouse enters this zone. Return false to
## reject it: no snapping and no placement will happen for this hover.
var canAcceptItem: Callable = Callable()

var _wasDragging: Dictionary = {}
var _wasInZone: Dictionary = {}
var _accepted: Dictionary = {}
var _placedGrabables: Dictionary = {}

func _process(_delta: float) -> void:
	for grabable in get_tree().get_nodes_in_group("grabable"):
		var isDrag := (grabable as GrabableComponent).isDragging()
		var wasDrag: bool = _wasDragging.get(grabable, false)
		var node := (grabable as GrabableComponent).get_parent() as Node2D

		if isDrag:
			if not wasDrag and _placedGrabables.get(grabable, false):
				_removeItem(grabable)

			var inZone := _isMouseInZone()
			var wasInZone: bool = _wasInZone.get(grabable, false)

			if node != null:
				if inZone and not wasInZone:
					_accepted[grabable] = _requestAccept(node)
				elif not inZone and wasInZone:
					_accepted[grabable] = false
					item_unhovered.emit(node)

				if inZone and _accepted.get(grabable, false):
					node.global_position = global_position

			_wasInZone[grabable] = inZone
		elif wasDrag:
			if node != null and _isMouseInZone() and _accepted.get(grabable, false):
				_placeItem(node, grabable)
			_accepted.erase(grabable)
			_wasInZone.erase(grabable)

		_wasDragging[grabable] = isDrag

func _requestAccept(node: Node2D) -> bool:
	if canAcceptItem.is_valid():
		return canAcceptItem.call(node)
	return true

func _isMouseInZone() -> bool:
	var mousePos := get_global_mouse_position()
	var spaceState := get_world_2d().direct_space_state
	var query := PhysicsPointQueryParameters2D.new()
	query.position = mousePos
	query.collide_with_areas = true
	query.collide_with_bodies = false

	for result in spaceState.intersect_point(query):
		if result["collider"] == self:
			return true
	return false

func getPlacementPosition() -> Vector2:
	var host := get_parent()
	if host is Control:
		var control := host as Control
		return control.global_position + control.size / 2.0
	elif host is CanvasItem:
		return (host as CanvasItem).get_global_transform().origin
	return global_position

func _placeItem(node: Node2D, grabable: Node) -> void:
	node.global_position = getPlacementPosition()
	_placedGrabables[grabable] = true
	onItemPlaced(node)

func _removeItem(grabable: Node) -> void:
	_placedGrabables.erase(grabable)
	var node := (grabable as GrabableComponent).get_parent() as Node2D
	if node != null:
		onItemRemoved(node)

## Forces this magnet's ownership bookkeeping to match an externally-decided
## occupant (used when a card is repositioned into/out of this zone without
## going through a real drag, e.g. when the queue shifts cards around).
func setPlacedItem(node: Node2D) -> void:
	_placedGrabables.clear()
	if node == null:
		return
	var grabable := _findGrabableComponent(node)
	if grabable != null:
		_placedGrabables[grabable] = true

func _findGrabableComponent(node: Node2D) -> Node:
	for child in node.get_children():
		if child is GrabableComponent:
			return child
	return null

func onItemPlaced(node: Node2D) -> void:
	item_placed.emit(node)

func onItemRemoved(node: Node2D) -> void:
	item_removed.emit(node)
