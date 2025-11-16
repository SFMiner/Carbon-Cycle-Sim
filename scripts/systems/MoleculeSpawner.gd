extends Node2D
class_name MoleculeSpawner

@export var molecule_scene: PackedScene
@export var spawn_rate: float = 2.0
@export var spawn_zone_min: Vector2 = Vector2.ZERO
@export var spawn_zone_max: Vector2 = Vector2(1280, 720)
@export var max_molecules: int = 30
@export var enabled: bool = true
@export var destroy_on_clear: bool = false  # if true, we free everything instead of pooling

var spawn_timer: Timer
var active_molecules: Array[Molecule] = []
var molecule_pool: Array[Molecule] = []

func _ready() -> void:
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	_update_timer_rate()
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	if enabled:
		spawn_timer.start()

func _update_timer_rate() -> void:
	spawn_timer.wait_time = 1.0 / max(0.001, spawn_rate)

func _on_spawn_timer_timeout() -> void:
	if enabled and active_molecules.size() < max_molecules:
		spawn_molecule()

func _safe_pop_pooled() -> Molecule:
	var m: Molecule = null
	while molecule_pool.size() > 0 and m == null:
		var candidate = molecule_pool.pop_back()
		if is_instance_valid(candidate):
			m = candidate
	return m

func spawn_molecule() -> void:
	var molecule: Molecule = _safe_pop_pooled()

	if molecule:
		# Reactivate
		molecule.visible = true
		molecule.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		if molecule_scene:
			molecule = molecule_scene.instantiate() as Molecule
			# Parent where you want them to live:
			get_tree().current_scene.add_child(molecule)
			# IMPORTANT: Molecule must NOT queue_free() itself when pooling.
			# It should emit `despawned` and let the spawner handle it.
			if not molecule.despawned.is_connected(_on_molecule_despawned):
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

		# Check if this is a photon - set up rain behavior
		if molecule.molecule_type == Molecule.MoleculeType.PHOTON:
			molecule.current_state = Molecule.State.PHOTON_RAIN
			molecule.can_be_grabbed = false

			# Random slope between -3.0 and 3.0
			var slope = randf_range(-3.0, 3.0)
			# Base downward speed: 720 pixels/second
			var base_speed = 720.0
			# Calculate velocity with slope
			molecule.rain_velocity = Vector2(slope * base_speed / 10.0, base_speed)
		else:
			molecule.current_state = Molecule.State.IDLE

		active_molecules.append(molecule)

func _on_molecule_despawned(molecule: Molecule) -> void:
	active_molecules.erase(molecule)
	# POOL: do NOT free
	if is_instance_valid(molecule):
		molecule.visible = false
		molecule.process_mode = Node.PROCESS_MODE_DISABLED
		molecule_pool.append(molecule)

func clear_all_molecules() -> void:
	# Prevent races while clearing
	if spawn_timer: spawn_timer.stop()

	if destroy_on_clear:
		# True destruction: free everything and empty the pool
		for m in active_molecules:
			if is_instance_valid(m): m.queue_free()
		active_molecules.clear()

		for m in molecule_pool:
			if is_instance_valid(m): m.queue_free()
		molecule_pool.clear()
	else:
		# Pooling clear: move actives into the pool (no frees)
		for m in active_molecules:
			if is_instance_valid(m):
				m.visible = false
				m.process_mode = Node.PROCESS_MODE_DISABLED
				molecule_pool.append(m)
		active_molecules.clear()

	if enabled and spawn_timer: spawn_timer.start()

func set_enabled(value: bool) -> void:
	enabled = value
	if spawn_timer:
		if enabled: spawn_timer.start()
		else: spawn_timer.stop()
