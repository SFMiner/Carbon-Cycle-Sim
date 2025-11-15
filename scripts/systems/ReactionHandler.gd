extends Node
class_name ReactionHandler

enum ReactionType {PHOTOSYNTHESIS, RESPIRATION}

signal reaction_triggered(type: ReactionType, input_molecules: Array[Molecule], output_info: Dictionary)

@export var workspace: Workspace
@export var reaction_type: ReactionType = ReactionType.PHOTOSYNTHESIS
@export var enabled: bool = true

# Tracking
var reaction_cooldown: float = 0.0
const REACTION_COOLDOWN_TIME: float = 0.1  # Prevent double-triggers


func _ready() -> void:
	if not workspace:
		push_error("ReactionHandler requires a Workspace reference")
		return

	# Connect to workspace signals
	workspace.molecule_entered.connect(_check_reaction_conditions)
	workspace.molecule_exited.connect(_check_reaction_conditions.unbind(1))


func _process(delta: float) -> void:
	if reaction_cooldown > 0:
		reaction_cooldown -= delta


func _check_reaction_conditions(_molecule: Molecule = null) -> void:
	"""Check if reaction requirements are met."""
	if not enabled or reaction_cooldown > 0:
		return

	match reaction_type:
		ReactionType.PHOTOSYNTHESIS:
			_check_photosynthesis()
		ReactionType.RESPIRATION:
			_check_respiration()


func _check_photosynthesis() -> void:
	"""Check for: 6 CO2 + 6 H2O + 12 photons → glucose + 6 O2."""
	var co2_count = 0
	var h2o_count = 0
	var photon_count = 0

	var co2_molecules: Array[Molecule] = []
	var h2o_molecules: Array[Molecule] = []
	var photon_molecules: Array[Molecule] = []

	# Count molecules, excluding those being dragged
	for molecule in workspace.molecules_in_workspace:
		if molecule.current_state == Molecule.State.BEING_DRAGGED:
			continue

		match molecule.molecule_type:
			Molecule.MoleculeType.CO2:
				co2_count += 1
				co2_molecules.append(molecule)
			Molecule.MoleculeType.H2O:
				h2o_count += 1
				h2o_molecules.append(molecule)
			Molecule.MoleculeType.PHOTON:
				photon_count += 1
				photon_molecules.append(molecule)

	# Check if requirements met
	if (co2_count >= GameConstants.PHOTOSYNTHESIS_CO2_NEEDED and
		h2o_count >= GameConstants.PHOTOSYNTHESIS_H2O_NEEDED and
		photon_count >= GameConstants.PHOTOSYNTHESIS_PHOTONS_NEEDED):

		# Collect exact number needed
		var input_molecules: Array[Molecule] = []
		input_molecules.append_array(co2_molecules.slice(0, GameConstants.PHOTOSYNTHESIS_CO2_NEEDED))
		input_molecules.append_array(h2o_molecules.slice(0, GameConstants.PHOTOSYNTHESIS_H2O_NEEDED))
		input_molecules.append_array(photon_molecules.slice(0, GameConstants.PHOTOSYNTHESIS_PHOTONS_NEEDED))

		# Prepare output info
		var output_info = {
			"glucose_count": GameConstants.PHOTOSYNTHESIS_GLUCOSE_PRODUCED,
			"o2_count": GameConstants.PHOTOSYNTHESIS_O2_PRODUCED
		}

		# Trigger reaction
		trigger_reaction(ReactionType.PHOTOSYNTHESIS, input_molecules, output_info)


func _check_respiration() -> void:
	"""Check for: 1 glucose + 6 O2 → 6 CO2 + 6 H2O + ATP."""
	var glucose_count = 0
	var o2_count = 0

	var glucose_molecules: Array[Molecule] = []
	var o2_molecules: Array[Molecule] = []

	# Count molecules, excluding those being dragged
	for molecule in workspace.molecules_in_workspace:
		if molecule.current_state == Molecule.State.BEING_DRAGGED:
			continue

		match molecule.molecule_type:
			Molecule.MoleculeType.GLUCOSE:
				glucose_count += 1
				glucose_molecules.append(molecule)
			Molecule.MoleculeType.O2:
				o2_count += 1
				o2_molecules.append(molecule)

	# Check if requirements met
	if (glucose_count >= GameConstants.RESPIRATION_GLUCOSE_NEEDED and
		o2_count >= GameConstants.RESPIRATION_O2_NEEDED):

		# Collect exact number needed
		var input_molecules: Array[Molecule] = []
		input_molecules.append_array(glucose_molecules.slice(0, GameConstants.RESPIRATION_GLUCOSE_NEEDED))
		input_molecules.append_array(o2_molecules.slice(0, GameConstants.RESPIRATION_O2_NEEDED))

		# Prepare output info
		var output_info = {
			"co2_count": GameConstants.RESPIRATION_CO2_PRODUCED,
			"h2o_count": GameConstants.RESPIRATION_H2O_PRODUCED,
			"atp_count": GameConstants.RESPIRATION_ATP_PRODUCED
		}

		# Trigger reaction
		trigger_reaction(ReactionType.RESPIRATION, input_molecules, output_info)


func trigger_reaction(type: ReactionType, input_molecules: Array[Molecule], output_info: Dictionary) -> void:
	"""Emit reaction signal and set cooldown."""

	# Remove molecules from workspace BEFORE animation
	for molecule in input_molecules:
		if molecule in workspace.molecules_in_workspace:
			workspace.molecules_in_workspace.erase(molecule)

	# Update workspace state
	if workspace.is_full and workspace.molecules_in_workspace.size() < workspace.capacity:
		workspace.is_full = false
		workspace.capacity_available.emit()
		workspace.update_visual()

	reaction_cooldown = REACTION_COOLDOWN_TIME
	reaction_triggered.emit(type, input_molecules, output_info)
