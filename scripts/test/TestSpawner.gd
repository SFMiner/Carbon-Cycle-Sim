extends Node2D

var molecules_deleted: int = 0
var reactions_occurred: int = 0


func _ready() -> void:
	$Workspace.capacity_reached.connect(_on_workspace_full)
	$Workspace.capacity_available.connect(_on_workspace_available)
	$TrashZone.molecule_deleted.connect(_on_molecule_deleted)
	$ReactionHandler.reaction_triggered.connect(_on_reaction_triggered)
	$ReactionEffect.animation_complete.connect(_on_reaction_complete)


func _process(delta: float) -> void:
	var total = 0
	total += $PhotonSpawner.active_molecules.size()
	total += $CO2Spawner.active_molecules.size()
	total += $H2OSpawner.active_molecules.size()

	var in_workspace = $Workspace.get_molecule_count()

	$DebugLabel.text = "Total: %d | Workspace: %d/20 | Deleted: %d | Reactions: %d" % [total, in_workspace, molecules_deleted, reactions_occurred]

	if $Workspace.is_at_capacity():
		$DebugLabel.modulate = Color.RED
	else:
		$DebugLabel.modulate = Color.WHITE


func _on_workspace_full() -> void:
	print("Workspace is full!")


func _on_workspace_available() -> void:
	print("Workspace has space available")


func _on_molecule_deleted(molecule: Molecule) -> void:
	molecules_deleted += 1
	print("Molecule deleted! Total: ", molecules_deleted)


func _on_reaction_triggered(type: ReactionHandler.ReactionType, input_molecules: Array, output_info: Dictionary) -> void:
	print("Reaction triggered! Type: ", type, " Inputs: ", input_molecules.size())
	reactions_occurred += 1

	# Determine pulse color and audio based on reaction type
	var pulse_color = Color.GREEN
	var sound_type = AudioManager.SoundType.REACTION_PHOTOSYNTHESIS
	if type == ReactionHandler.ReactionType.RESPIRATION:
		pulse_color = Color.ORANGE
		sound_type = AudioManager.SoundType.REACTION_RESPIRATION

	# Effects
	$Workspace.pulse_reaction(pulse_color)
	$CameraShake.shake()
	AudioManager.play_sound(sound_type)

	# Animation
	$ReactionEffect.play_reaction($Workspace.global_position, input_molecules, output_info)


func _on_reaction_complete() -> void:
	print("Reaction animation complete")
