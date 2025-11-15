extends CanvasLayer
class_name HUD_Stage1

@onready var progress_label: Label = $TopPanel/ProgressLabel
@onready var co2_label: Label = $LeftPanel/VBoxContainer/CO2Label
@onready var h2o_label: Label = $LeftPanel/VBoxContainer/H2OLabel
@onready var photon_label: Label = $LeftPanel/VBoxContainer/PhotonLabel
@onready var warning_label: Label = $WarningLabel
@onready var restart_button: Button = $RestartButton
@onready var help_button: Button = $HelpButton

signal restart_requested()
signal help_requested()


func _ready() -> void:
	# Connect buttons
	restart_button.pressed.connect(_on_restart_pressed)
	help_button.pressed.connect(_on_help_pressed)

	# Connect GameManager signals
	GameManager.glucose_created_updated.connect(_on_glucose_updated)

	# Initial update
	update_progress(0)


func _process(_delta: float) -> void:
	# Update molecule counters each frame
	update_molecule_counts()


func update_molecule_counts() -> void:
	"""Count molecules in scene and update labels."""
	var co2_count = 0
	var h2o_count = 0
	var photon_count = 0

	# Get workspace reference
	var workspace = get_node_or_null("/root/Stage1/Workspace")
	if workspace and workspace is Workspace:
		for molecule in workspace.molecules_in_workspace:
			match molecule.molecule_type:
				Molecule.MoleculeType.CO2:
					co2_count += 1
				Molecule.MoleculeType.H2O:
					h2o_count += 1
				Molecule.MoleculeType.PHOTON:
					photon_count += 1

		# Also get photons from counter
		photon_count = workspace.get_photon_count()

	# Update labels
	co2_label.text = "CO₂: %d" % co2_count
	h2o_label.text = "H₂O: %d" % h2o_count
	photon_label.text = "Photons: %d/24" % photon_count


func update_progress(glucose_count: int) -> void:
	"""Update glucose counter."""
	progress_label.text = "Glucose Created: %d/%d" % [glucose_count, GameConstants.STAGE1_GLUCOSE_TARGET]


func show_workspace_full_warning(show: bool) -> void:
	"""Show/hide workspace full warning."""
	warning_label.visible = show


func _on_glucose_updated(count: int) -> void:
	update_progress(count)


func _on_restart_pressed() -> void:
	restart_requested.emit()


func _on_help_pressed() -> void:
	help_requested.emit()
