extends CanvasLayer

enum TransitionType { FADE, LOADING_SCREEN }

const FADE_DURATION = 0.5

@onready var fadeRect: ColorRect = %FadeRect
@onready var loadingScreen: Control = %LoadingScreen
@onready var loadingBar: ProgressBar = %LoadingBar
@onready var loadingLabel: Label = %LoadingLabel

var _isTransitioning: bool = false
var _targetScenePath: String = ""

func _input(event: InputEvent) -> void:
	if _isTransitioning:
		return
	if not (event is InputEventKey and event.pressed and not event.echo):
		return

func transitionToScene(scenePath: String, type: TransitionType = TransitionType.FADE) -> void:
	if _isTransitioning:
		return
	_isTransitioning = true
	_targetScenePath = scenePath

	if type == TransitionType.FADE:
		await _doFadeTransition()
	else:
		await _doLoadingScreenTransition()

	_isTransitioning = false

func _doFadeTransition() -> void:
	fadeRect.mouse_filter = Control.MOUSE_FILTER_STOP
	var tween := create_tween()
	tween.tween_property(fadeRect, "modulate:a", 1.0, FADE_DURATION)
	await tween.finished

	get_tree().change_scene_to_file(_targetScenePath)

	tween = create_tween()
	tween.tween_property(fadeRect, "modulate:a", 0.0, FADE_DURATION)
	await tween.finished
	fadeRect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _doLoadingScreenTransition() -> void:
	loadingScreen.visible = true
	loadingBar.value = 0.0
	loadingLabel.text = "Loading..."

	var error := ResourceLoader.load_threaded_request(_targetScenePath)
	if error != OK:
		loadingScreen.visible = false
		return

	while true:
		var progress: Array = []
		var status := ResourceLoader.load_threaded_get_status(_targetScenePath, progress)

		match status:
			ResourceLoader.THREAD_LOAD_LOADED:
				break
			ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				loadingScreen.visible = false
				return

		if progress.size() > 0:
			loadingBar.value = progress[0] * 100.0

		await get_tree().process_frame

	loadingBar.value = 100.0
	await get_tree().create_timer(0.3).timeout

	var scene: PackedScene = ResourceLoader.load_threaded_get(_targetScenePath)
	get_tree().change_scene_to_packed(scene)
	loadingScreen.visible = false
