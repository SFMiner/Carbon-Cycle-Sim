extends Area2D
class_name Molecule

enum MoleculeType {PHOTON, CO2, H2O, O2, GLUCOSE}
enum State {IDLE, BEING_DRAGGED, IN_WORKSPACE, DESPAWNING, PHOTON_RAIN}

@export var molecule_type: MoleculeType = MoleculeType.CO2
var current_state: State = State.IDLE
var drag_offset: Vector2 = Vector2.ZERO
var time_since_spawn: float = 0.0
var can_be_grabbed: bool = true
var grab_cooldown_timer: float = 0.0
var rain_velocity: Vector2 = Vector2.ZERO  # For photon rain movement

signal picked_up(molecule: Molecule)
signal dropped(molecule: Molecule, position: Vector2)
signal entered_workspace(molecule: Molecule)
signal exited_workspace(molecule: Molecule)
signal despawned(molecule: Molecule)


func _ready() -> void:
	# Configure collision
	collision_layer = 2  # Layer 2 for molecules
	collision_mask = 0   # Don't collide with anything
	monitoring = true
	monitorable = true
	$Label.text = MoleculeType.keys()[molecule_type]
	# Adjust collision size for glucose
	if molecule_type == MoleculeType.GLUCOSE:
		var collision = get_node("CollisionShape") as CollisionShape2D
		if collision and collision.shape is CircleShape2D:
			collision.shape.radius = 64

	# Connect input events
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _process(delta: float) -> void:
	match current_state:
		State.IDLE:
			_process_idle(delta)
		State.BEING_DRAGGED:
			_process_dragging(delta)
		State.IN_WORKSPACE:
			_process_in_workspace(delta)
		State.DESPAWNING:
			_process_despawning(delta)
		State.PHOTON_RAIN:
			_process_photon_rain(delta)

	# Update grab cooldown
	if grab_cooldown_timer > 0:
		grab_cooldown_timer -= delta
		can_be_grabbed = grab_cooldown_timer <= 0


func _process_idle(delta: float) -> void:
	time_since_spawn += delta
	if time_since_spawn >= GameConstants.MOLECULE_DESPAWN_TIME:
		despawn()

	# Apply separation force
	apply_separation_force(delta)


func _process_dragging(delta: float) -> void:
	global_position = get_global_mouse_position() + drag_offset


func _process_in_workspace(delta: float) -> void:
	# Apply separation force
	apply_separation_force(delta)


func _process_despawning(delta: float) -> void:
	pass  # Will implement fade-out animation later


func _process_photon_rain(delta: float) -> void:
	# Move photon downward with slope
	global_position += rain_velocity * delta

	# Despawn if off bottom of screen
	if global_position.y > 720 + 50:  # 50px buffer
		despawn()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if can_be_grabbed and current_state == State.IDLE:
			start_drag()


func _on_mouse_entered() -> void:
	if can_be_grabbed:
		show_hover_feedback()


func _on_mouse_exited() -> void:
	hide_hover_feedback()


func start_drag() -> void:
	current_state = State.BEING_DRAGGED
	drag_offset = global_position - get_global_mouse_position()
	z_index = 10
	scale = Vector2(1.1, 1.1)  # Slight scale up
	picked_up.emit(self)


func stop_drag() -> void:
	current_state = State.IDLE
	z_index = 0
	scale = Vector2(1.0, 1.0)  # Back to normal
	grab_cooldown_timer = GameConstants.MOLECULE_DRAG_COOLDOWN
	can_be_grabbed = false
	dropped.emit(self, global_position)


func despawn() -> void:
	current_state = State.DESPAWNING
	despawned.emit(self)
	queue_free()  # For now, will add animation later


func _input(event: InputEvent) -> void:
	if current_state == State.BEING_DRAGGED:
		if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			stop_drag()


func show_hover_feedback() -> void:
	var outline = get_node_or_null("HoverOutline")
	if outline:
		outline.visible = true
		outline.default_color = Color.WHITE


func hide_hover_feedback() -> void:
	var outline = get_node_or_null("HoverOutline")
	if outline:
		outline.visible = false


func apply_separation_force(delta: float) -> void:
	"""Push away from nearby molecules to prevent overlap."""
	var separation_velocity = Vector2.ZERO
	var nearby_count = 0

	# Get all overlapping areas
	var overlapping = get_overlapping_areas()
	for area in overlapping:
		if area is Molecule and area != self:
			# Calculate direction away from other molecule
			var direction = global_position - area.global_position
			var distance = direction.length()

			# Only separate if very close
			if distance < GameConstants.MOLECULE_COLLISION_RADIUS * 2:
				if distance > 0:
					direction = direction.normalized()
					# Closer = stronger push
					var strength = 1.0 - (distance / (GameConstants.MOLECULE_COLLISION_RADIUS * 2))
					separation_velocity += direction * strength
					nearby_count += 1

	# Apply average separation
	if nearby_count > 0:
		separation_velocity = separation_velocity / nearby_count
		separation_velocity *= GameConstants.MOLECULE_SEPARATION_FORCE
		global_position += separation_velocity * delta
