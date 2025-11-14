extends Area2D
class_name Workspace

signal molecule_entered(molecule: Molecule)
signal molecule_exited(molecule: Molecule)
signal capacity_reached()
signal capacity_available()

@export var capacity: int = 20
@export var workspace_color: Color = Color.GREEN
@export var full_color: Color = Color.RED

var molecules_in_workspace: Array[Molecule] = []
var is_full: bool = false


func _ready() -> void:
	# Configure collision
	collision_layer = 4  # Layer 4 for workspace
	collision_mask = 2   # Detect layer 2 (molecules)
	monitoring = true
	monitorable = false

	# Connect signals
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

	# Update visual
	update_visual()


func _on_area_entered(area: Area2D) -> void:
	if area is Molecule:
		var molecule = area as Molecule

		# Check if workspace is full
		if molecules_in_workspace.size() >= capacity:
			if not is_full:
				is_full = true
				capacity_reached.emit()
				update_visual()
			return

		# Add to workspace
		if molecule not in molecules_in_workspace:
			molecules_in_workspace.append(molecule)
			molecule.current_state = Molecule.State.IN_WORKSPACE
			molecule_entered.emit(molecule)

			# Check if now full
			if molecules_in_workspace.size() >= capacity:
				is_full = true
				capacity_reached.emit()
				update_visual()


func _on_area_exited(area: Area2D) -> void:
	if area is Molecule:
		var molecule = area as Molecule

		if molecule in molecules_in_workspace:
			molecules_in_workspace.erase(molecule)
			if molecule.current_state == Molecule.State.IN_WORKSPACE:
				molecule.current_state = Molecule.State.IDLE
			molecule_exited.emit(molecule)

			# Check if no longer full
			if is_full and molecules_in_workspace.size() < capacity:
				is_full = false
				capacity_available.emit()
				update_visual()


func get_molecule_count() -> int:
	return molecules_in_workspace.size()


func is_at_capacity() -> bool:
	return is_full


func update_visual() -> void:
	# Update border color based on capacity
	var border = get_node_or_null("Border")
	if border and border is Line2D:
		if is_full:
			border.default_color = full_color
		else:
			border.default_color = workspace_color


func clear_molecules() -> void:
	"""Remove all molecules from workspace (for reset)."""
	for molecule in molecules_in_workspace:
		molecule.current_state = Molecule.State.IDLE
	molecules_in_workspace.clear()
	is_full = false
	update_visual()
