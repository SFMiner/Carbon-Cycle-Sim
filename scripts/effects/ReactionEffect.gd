extends Node2D
class_name ReactionEffect

@export var effect_color: Color = Color.GREEN
@export var duration: float = 0.8

signal animation_complete()
signal spawn_outputs(output_info: Dictionary, center_pos: Vector2)


func _ready() -> void:
	visible = false


func play_reaction(center_pos: Vector2, input_molecules: Array[Molecule], output_info: Dictionary = {}) -> void:
	"""Animate molecules swirling into center and spawn outputs."""
	visible = true
	global_position = center_pos

	# Create tween for swirl animation
	var tween = create_tween()
	tween.set_parallel(true)

	# Animate each input molecule
	for molecule in input_molecules:
		# Swirl to center
		tween.tween_property(
			molecule, "global_position",
			center_pos,
			duration
		).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)

		# Scale down
		tween.tween_property(
			molecule, "scale",
			Vector2.ZERO,
			duration
		).set_ease(Tween.EASE_IN)

	# Flash effect at center
	tween.tween_callback(_flash_center.bind(center_pos))

	# Spawn outputs after flash
	tween.tween_callback(func():
		spawn_outputs.emit(output_info, center_pos)
	).set_delay(0.2)

	# Clean up molecules after animation
	tween.finished.connect(func():
		for molecule in input_molecules:
			molecule.queue_free()
		animation_complete.emit()
		visible = false
	)


func _flash_center(center_pos: Vector2) -> void:
	"""Create visual flash at reaction center."""
	# Create flash sprite
	var flash = Sprite2D.new()
	get_tree().current_scene.add_child(flash)
	flash.global_position = center_pos

	# Create circular gradient texture
	var gradient_texture = GradientTexture2D.new()
	gradient_texture.width = 200
	gradient_texture.height = 200
	gradient_texture.fill = GradientTexture2D.FILL_RADIAL

	var gradient = Gradient.new()
	gradient.set_color(0, effect_color)
	gradient.set_color(1, Color(effect_color, 0))  # Transparent at edges
	gradient_texture.gradient = gradient

	flash.texture = gradient_texture

	# Animate flash
	var flash_tween = create_tween()
	flash_tween.tween_property(flash, "scale", Vector2(3, 3), 0.3)
	flash_tween.parallel().tween_property(flash, "modulate:a", 0.0, 0.3)
	flash_tween.finished.connect(func(): flash.queue_free())
