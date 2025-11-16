extends Node2D
class_name Stage1Controller

signal stage_complete()

@export var reaction_handler: ReactionHandler
@export var reaction_effect: ReactionEffect
@export var output_spawner: OutputSpawner
@export var workspace: Workspace
@export var camera_shake: CameraShake
@export var tutorial_overlay: TutorialOverlay
@export var stage_complete_overlay: StageComplete

var glucose_created: int = 0
var target_glucose: int = GameConstants.STAGE1_GLUCOSE_TARGET
var stage_start_time: float = 0.0
var reaction_count: int = 0


func _ready() -> void:
	# Initialize GameManager
	GameManager.start_stage(1)
	stage_start_time = Time.get_ticks_msec() / 1000.0

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

	if stage_complete_overlay:
		stage_complete_overlay.continue_pressed.connect(_on_stage_complete_continue)

	# Show tutorial on first run
	if not SaveSystem.save_data["settings"]["tutorial_seen"][0]:
		show_tutorial()

	# Connect GameManager signals for UI updates
	GameManager.glucose_created_updated.connect(_on_glucose_updated)


func _on_reaction_triggered(type: ReactionHandler.ReactionType, input_molecules: Array[Molecule], output_info: Dictionary) -> void:
	"""Handle photosynthesis reaction."""
	reaction_count += 1

	# Visual effects
	if workspace:
		workspace.pulse_reaction(Color.GREEN)

	if camera_shake:
		camera_shake.shake()

	# Audio
	AudioManager.play_sound(AudioManager.SoundType.REACTION_PHOTOSYNTHESIS)

	# Animation
	if reaction_effect and workspace:
		reaction_effect.play_reaction(workspace.global_position, input_molecules, output_info)


func _on_spawn_outputs(output_info: Dictionary, center_pos: Vector2) -> void:
	"""Spawn glucose and O2."""
	if output_spawner:
		output_spawner.spawn_photosynthesis_outputs(center_pos)


func _on_reaction_complete() -> void:
	"""Reaction animation finished."""
	print("Reaction complete!")


func _on_glucose_updated(count: int) -> void:
	"""Track glucose creation."""
	glucose_created = count

	# Check win condition
	if glucose_created >= target_glucose:
		complete_stage()


func complete_stage() -> void:
	"""Stage 1 complete - show completion screen."""
	print("Stage 1 Complete!")
	stage_complete.emit()
	GameManager.complete_stage(1)

	# Calculate statistics
	var elapsed_time = (Time.get_ticks_msec() / 1000.0) - stage_start_time
	var efficiency = float(glucose_created) / float(reaction_count) if reaction_count > 0 else 0.0

	# Show stage complete screen
	if stage_complete_overlay:
		stage_complete_overlay.show_completion(1, elapsed_time, reaction_count, efficiency)


func restart_stage() -> void:
	"""Restart Stage 1 from beginning."""
	# Clear all molecules
	var molecules = get_tree().get_nodes_in_group("molecules")
	for molecule in molecules:
		molecule.queue_free()

	# Reset workspace
	if workspace:
		workspace.clear_molecules()

	# Reset counters
	GameManager.start_stage(1)
	glucose_created = 0


func _on_workspace_full() -> void:
	var hud = get_node_or_null("HUD")
	if hud and hud.has_method("show_workspace_full_warning"):
		hud.show_workspace_full_warning(true)


func _on_workspace_available() -> void:
	var hud = get_node_or_null("HUD")
	if hud and hud.has_method("show_workspace_full_warning"):
		hud.show_workspace_full_warning(false)


func show_tutorial() -> void:
	"""Show tutorial steps for Stage 1."""
	if not tutorial_overlay:
		return

	var steps: Array[Dictionary] = [
		{"text": "Welcome to Stage 1!\n\nDrag photons into the green chloroplast."},
		{"text": "Drag CO₂ molecules from the air."},
		{"text": "Drag H₂O molecules from the roots."},
		{"text": "Collect 6 CO₂ + 6 H₂O + 12 photons to make glucose!"}
	]

	tutorial_overlay.show_tutorial(steps)


func _on_tutorial_complete() -> void:
	"""Save tutorial seen state."""
	SaveSystem.save_data["settings"]["tutorial_seen"][0] = true
	SaveSystem.save_game()


func _on_stage_complete_continue() -> void:
	"""Fade to next stage."""
	# TODO: Implement fade transition to Stage 2
	pass
