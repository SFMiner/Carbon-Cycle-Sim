extends Node
class_name OutputSpawner

@export var glucose_scene: PackedScene
@export var o2_scene: PackedScene
@export var co2_scene: PackedScene
@export var h2o_scene: PackedScene


func spawn_photosynthesis_outputs(center_pos: Vector2) -> void:
	"""Spawn 1 glucose and 6 O2."""
	# Spawn glucose at center
	if glucose_scene:
		var glucose = glucose_scene.instantiate() as Molecule
		get_tree().current_scene.add_child(glucose)
		glucose.global_position = center_pos
		glucose.scale = Vector2.ZERO

		# Animate scale up
		var tween = create_tween()
		tween.tween_property(
			glucose, "scale",
			Vector2(1, 1),
			GameConstants.REACTION_SCALE_DURATION
		)

	# Spawn O2 molecules in circle around center
	if o2_scene:
		for i in range(GameConstants.PHOTOSYNTHESIS_O2_PRODUCED):
			var o2 = o2_scene.instantiate() as Molecule
			get_tree().current_scene.add_child(o2)
			o2.global_position = center_pos
			o2.scale = Vector2.ZERO

			# Calculate position in circle
			var angle = (TAU / GameConstants.PHOTOSYNTHESIS_O2_PRODUCED) * i
			var target_pos = center_pos + Vector2(cos(angle), sin(angle)) * 100

			# Animate scale up and drift away
			var tween = create_tween()
			tween.tween_property(
				o2, "scale",
				Vector2(1, 1),
				GameConstants.REACTION_SCALE_DURATION
			)
			tween.parallel().tween_property(
				o2, "global_position",
				target_pos,
				GameConstants.O2_DRIFT_DURATION
			).set_ease(Tween.EASE_OUT)

	# Update GameManager
	GameManager.increment_glucose_created()


func spawn_respiration_outputs(center_pos: Vector2) -> void:
	"""Spawn 6 CO2, 6 H2O, and 3 ATP bolts."""
	# Spawn CO2 molecules
	if co2_scene:
		for i in range(GameConstants.RESPIRATION_CO2_PRODUCED):
			var co2 = co2_scene.instantiate() as Molecule
			get_tree().current_scene.add_child(co2)

			var angle = (TAU / GameConstants.RESPIRATION_CO2_PRODUCED) * i
			var target_pos = center_pos + Vector2(cos(angle), sin(angle)) * 100

			co2.global_position = center_pos
			co2.scale = Vector2.ZERO

			var tween = create_tween()
			tween.tween_property(co2, "scale", Vector2(1, 1), GameConstants.REACTION_SCALE_DURATION)
			tween.parallel().tween_property(co2, "global_position", target_pos, GameConstants.O2_DRIFT_DURATION).set_ease(Tween.EASE_OUT)

	# Spawn H2O molecules
	if h2o_scene:
		for i in range(GameConstants.RESPIRATION_H2O_PRODUCED):
			var h2o = h2o_scene.instantiate() as Molecule
			get_tree().current_scene.add_child(h2o)

			var angle = (TAU / GameConstants.RESPIRATION_H2O_PRODUCED) * i + (TAU / 12)  # Offset from CO2
			var target_pos = center_pos + Vector2(cos(angle), sin(angle)) * 80

			h2o.global_position = center_pos
			h2o.scale = Vector2.ZERO

			var tween = create_tween()
			tween.tween_property(h2o, "scale", Vector2(1, 1), GameConstants.REACTION_SCALE_DURATION)
			tween.parallel().tween_property(h2o, "global_position", target_pos, GameConstants.O2_DRIFT_DURATION).set_ease(Tween.EASE_OUT)

	# Spawn ATP bolts
	var atp_bolt_scene = preload("res://scenes/effects/ATPBolt.tscn")
	for i in range(GameConstants.RESPIRATION_ATP_PRODUCED):
		var bolt = atp_bolt_scene.instantiate() as ATPBolt
		get_tree().current_scene.add_child(bolt)
		bolt.global_position = center_pos

		# Set direction (120° apart for 3 bolts)
		var angle = (360.0 / GameConstants.RESPIRATION_ATP_PRODUCED) * i
		bolt.set_direction(angle)

	# Update GameManager
	GameManager.increment_glucose_broken()
