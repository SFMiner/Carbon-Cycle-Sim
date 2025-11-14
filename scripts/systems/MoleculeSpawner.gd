extends Node2D
class_name MoleculeSpawner

# Spawner configuration
@export var molecule_scene: PackedScene
@export var spawn_rate: float = 2.0  # molecules per second
@export var spawn_zone_min: Vector2 = Vector2.ZERO
@export var spawn_zone_max: Vector2 = Vector2(100, 100)
@export var max_molecules: int = 30
@export var enabled: bool = true

# Internal state
var spawn_timer: Timer
var active_molecules: Array[Molecule] = []
var molecule_pool: Array[Molecule] = []


func _ready() -> void:
	# Create spawn timer
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = 1.0 / spawn_rate
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()


func _on_spawn_timer_timeout() -> void:
	if enabled and active_molecules.size() < max_molecules:
		spawn_molecule()


func spawn_molecule() -> void:
	var molecule: Molecule

	# Try to get from pool first
	if molecule_pool.size() > 0:
		molecule = molecule_pool.pop_back()
		molecule.visible = true
		molecule.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		# Create new instance
		if molecule_scene:
			molecule = molecule_scene.instantiate() as Molecule
			get_tree().current_scene.add_child(molecule)
			molecule.despawned.connect(_on_molecule_despawned)

	if molecule:
		# Set spawn position with random offset
		var spawn_pos = Vector2(
			randf_range(spawn_zone_min.x, spawn_zone_max.x),
			randf_range(spawn_zone_min.y, spawn_zone_max.y)
		)
		var offset = Vector2(
			randf_range(-GameConstants.SPAWN_OFFSET_RANGE, GameConstants.SPAWN_OFFSET_RANGE),
			randf_range(-GameConstants.SPAWN_OFFSET_RANGE, GameConstants.SPAWN_OFFSET_RANGE)
		)
		molecule.global_position = spawn_pos + offset
		molecule.time_since_spawn = 0.0
		molecule.current_state = Molecule.State.IDLE

		active_molecules.append(molecule)


func _on_molecule_despawned(molecule: Molecule) -> void:
	active_molecules.erase(molecule)

	# Return to pool instead of freeing
	molecule.visible = false
	molecule.process_mode = Node.PROCESS_MODE_DISABLED
	molecule_pool.append(molecule)


func clear_all_molecules() -> void:
	"""Remove all active molecules (for stage restart)."""
	for molecule in active_molecules:
		molecule.queue_free()
	active_molecules.clear()

	for molecule in molecule_pool:
		molecule.queue_free()
	molecule_pool.clear()


func set_enabled(value: bool) -> void:
	enabled = value
	if spawn_timer:
		if enabled:
			spawn_timer.start()
		else:
			spawn_timer.stop()
