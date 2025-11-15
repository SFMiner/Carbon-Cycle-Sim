extends CanvasLayer
class_name HUD_Stage2

@onready var progress_label: Label = $TopPanel/ProgressLabel
@onready var glucose_label: Label = $LeftPanel/VBoxContainer/GlucoseLabel
@onready var o2_label: Label = $LeftPanel/VBoxContainer/O2Label
@onready var energy_label: Label = $LeftPanel/VBoxContainer/EnergyLabel
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
	GameManager.glucose_broken_updated.connect(_on_glucose_updated)

	# Initial update
	update_progress(0)


func _process(_delta: float) -> void:
	# Update molecule counters each frame
	update_molecule_counts()


func update_molecule_counts() -> void:
	"""Count molecules in scene and update labels."""
	var glucose_count = 0
	var o2_count = 0

	# Get workspace reference
	var workspace = get_node_or_null("/root/Stage2/Workspace")
	if workspace and workspace is Workspace:
		for molecule in workspace.molecules_in_workspace:
			match molecule.molecule_type:
				Molecule.MoleculeType.GLUCOSE:
					glucose_count += 1
				Molecule.MoleculeType.O2:
					o2_count += 1

	# Update labels
	glucose_label.text = "Glucose: %d" % glucose_count
	o2_label.text = "O₂: %d" % o2_count
	energy_label.text = "Energy: %d ATP" % (GameManager.glucose_broken * 3)


func update_progress(glucose_count: int) -> void:
	"""Update glucose counter."""
	progress_label.text = "Glucose Broken: %d/%d" % [glucose_count, GameConstants.STAGE2_GLUCOSE_TARGET]


func show_workspace_full_warning(show: bool) -> void:
	"""Show/hide workspace full warning."""
	warning_label.visible = show


func _on_glucose_updated(count: int) -> void:
	update_progress(count)


func _on_restart_pressed() -> void:
	restart_requested.emit()


func _on_help_pressed() -> void:
	help_requested.emit()
