extends Node2D
class_name Stage2Controller

signal stage_complete()

@export var reaction_handler: ReactionHandler
@export var reaction_effect: ReactionEffect
@export var output_spawner: OutputSpawner
@export var workspace: Workspace
@export var camera_shake: CameraShake
@export var tutorial_overlay: TutorialOverlay

var glucose_broken: int = 0
var target_glucose: int = GameConstants.STAGE2_GLUCOSE_TARGET


func _ready() -> void:
	# Initialize GameManager
	GameManager.start_stage(2)

	# Connect signals
	if reaction_handler:
		reaction_handler.reaction_triggered.connect(_on_reaction_triggered)

	if reaction_effect:
		reaction_effect.spawn_outputs.connect(_on_spawn_outputs)
		reaction_effect.animation_complete.connect(_on_reaction_complete)

	if workspace:
		workspace.capacity_reached.connect(_on_workspace_full)
		workspace.capacity_available.connect(_on_workspace_available)

	if tutorial_overlay:
		tutorial_overlay.tutorial_complete.connect(_on_tutorial_complete)

	# Show tutorial on first run
	if not SaveSystem.save_data["settings"]["tutorial_seen"][1]:
		show_tutorial()

	# Connect GameManager signals for UI updates
	GameManager.glucose_broken_updated.connect(_on_glucose_updated)


func _on_reaction_triggered(type: ReactionHandler.ReactionType, input_molecules: Array[Molecule], output_info: Dictionary) -> void:
	"""Handle respiration reaction."""
	# Visual effects
	if workspace:
		workspace.pulse_reaction(Color.ORANGE)

	if camera_shake:
		camera_shake.shake()

	# Audio
	AudioManager.play_sound(AudioManager.SoundType.REACTION_RESPIRATION)

	# Animation
	if reaction_effect and workspace:
		reaction_effect.play_reaction(workspace.global_position, input_molecules, output_info)


func _on_spawn_outputs(output_info: Dictionary, center_pos: Vector2) -> void:
	"""Spawn CO2, H2O, and ATP."""
	if output_spawner:
		output_spawner.spawn_respiration_outputs(center_pos)


func _on_reaction_complete() -> void:
	"""Reaction animation finished."""
	print("Reaction complete!")


func _on_glucose_updated(count: int) -> void:
	"""Track glucose breakdown."""
	glucose_broken = count

	# Check win condition
	if glucose_broken >= target_glucose:
		complete_stage()


func complete_stage() -> void:
	"""Stage 2 complete."""
	print("Stage 2 Complete!")
	stage_complete.emit()
	GameManager.complete_stage(2)


func restart_stage() -> void:
	"""Restart Stage 2 from beginning."""
	# Clear all molecules
	var molecules = get_tree().get_nodes_in_group("molecules")
	for molecule in molecules:
		molecule.queue_free()

	# Reset workspace
	if workspace:
		workspace.clear_molecules()

	# Reset counters
	GameManager.start_stage(2)
	glucose_broken = 0


func _on_workspace_full() -> void:
	var hud = get_node_or_null("HUD")
	if hud and hud.has_method("show_workspace_full_warning"):
		hud.show_workspace_full_warning(true)


func _on_workspace_available() -> void:
	var hud = get_node_or_null("HUD")
	if hud and hud.has_method("show_workspace_full_warning"):
		hud.show_workspace_full_warning(false)


func show_tutorial() -> void:
	"""Show tutorial steps for Stage 2."""
	if not tutorial_overlay:
		return

	var steps: Array[Dictionary] = [
		{"text": "Welcome to Stage 2!\n\nDrag glucose into the mitochondrion."},
		{"text": "Drag O₂ molecules to help break down glucose."},
		{"text": "Collect 1 glucose + 6 O₂ to release energy!"}
	]

	tutorial_overlay.show_tutorial(steps)


func _on_tutorial_complete() -> void:
	"""Save tutorial seen state."""
	SaveSystem.save_data["settings"]["tutorial_seen"][1] = true
	SaveSystem.save_game()
