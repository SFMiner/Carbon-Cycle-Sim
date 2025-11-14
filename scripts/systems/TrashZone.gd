extends Area2D
class_name TrashZone

signal molecule_deleted(molecule: Molecule)

var deletion_tween: Tween


func _ready() -> void:
	# Configure collision
	collision_layer = 8  # Layer 4 for trash zone
	collision_mask = 2   # Detect layer 2 (molecules)
	monitoring = true
	monitorable = false

	# Connect signals
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area is Molecule:
		var molecule = area as Molecule

		# Only delete if dropped (not dragging through)
		if molecule.current_state == Molecule.State.IDLE:
			delete_molecule(molecule)


func delete_molecule(molecule: Molecule) -> void:
	"""Play deletion animation and remove molecule."""
	molecule_deleted.emit(molecule)

	# Create tween for deletion animation
	if deletion_tween:
		deletion_tween.kill()

	deletion_tween = create_tween()
	deletion_tween.set_parallel(true)

	# Shrink to zero scale
	deletion_tween.tween_property(
		molecule, "scale",
		Vector2.ZERO,
		GameConstants.DELETION_ANIMATION_DURATION
	)

	# Fade out
	deletion_tween.tween_property(
		molecule, "modulate:a",
		0.0,
		GameConstants.DELETION_ANIMATION_DURATION
	)

	# Delete when animation complete
	deletion_tween.finished.connect(func(): molecule.queue_free())
