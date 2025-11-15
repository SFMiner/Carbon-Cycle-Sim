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
var pulse_tween: Tween


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

	# Start idle pulse
	start_idle_pulse()


func _process(delta: float) -> void:
	check_for_dropped_molecules()


func _on_area_entered(area: Area2D) -> void:
	if area is Molecule:
		var molecule = area as Molecule

		# Ignore molecules that are being dragged
		if molecule.current_state == Molecule.State.BEING_DRAGGED:
			return

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


func check_for_dropped_molecules() -> void:
	"""Check for molecules that were dropped inside workspace."""
	# Skip if workspace is full
	if is_full:
		return

	# Get all overlapping areas
	var overlapping = get_overlapping_areas()

	for area in overlapping:
		if area is Molecule:
			var molecule = area as Molecule

			# Only process IDLE molecules not already tracked
			if molecule.current_state == Molecule.State.IDLE and molecule not in molecules_in_workspace:
				# Add to workspace
				molecules_in_workspace.append(molecule)
				molecule.current_state = Molecule.State.IN_WORKSPACE
				molecule_entered.emit(molecule)

				# Check if now full
				if molecules_in_workspace.size() >= capacity:
					is_full = true
					capacity_reached.emit()
					update_visual()
					return  # Stop checking once full


func pulse_reaction(reaction_color: Color) -> void:
	"""Pulse background glow on reaction."""
	var background = get_node_or_null("BackgroundGlow")
	if not background:
		return

	# Kill existing tween if running
	if pulse_tween:
		pulse_tween.kill()

	# Create pulse animation
	pulse_tween = create_tween()
	pulse_tween.tween_property(background, "modulate", Color(reaction_color, 0.8), 0.2)
	pulse_tween.tween_property(background, "modulate", Color(workspace_color, 0.3), 0.6)


func start_idle_pulse() -> void:
	"""Create looping breathing animation on background glow."""
	var background = get_node_or_null("BackgroundGlow")
	if not background:
		return

	# Create looping pulse tween
	pulse_tween = create_tween()
	pulse_tween.set_loops()
	pulse_tween.tween_property(background, "modulate", Color(workspace_color, 0.5), 1.5)
	pulse_tween.tween_property(background, "modulate", Color(workspace_color, 0.2), 1.5)
