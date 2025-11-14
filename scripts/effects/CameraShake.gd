extends Node
class_name CameraShake

@export var camera: Camera2D
@export var shake_amount: float = 5.0
@export var shake_duration: float = 0.2

var shake_tween: Tween
var original_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	if camera:
		original_offset = camera.offset


func shake() -> void:
	"""Shake the camera briefly."""
	if not camera:
		return

	# Kill existing shake
	if shake_tween:
		shake_tween.kill()

	# Reset to original
	camera.offset = original_offset

	# Create shake tween
	shake_tween = create_tween()

	# Shake in random directions
	var shake_steps = 4
	for i in range(shake_steps):
		var random_offset = Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
		shake_tween.tween_property(
			camera, "offset",
			random_offset,
			shake_duration / shake_steps
		)

	# Return to original
	shake_tween.tween_property(
		camera, "offset",
		original_offset,
		shake_duration / shake_steps
	)
