## Task 3.5: Photon Rain System Implementation

I'll create a series of small tasks suitable for Haiku 4.5:

---

### Task 3.5.1: Add PHOTON_RAIN State to Molecule

**Dependencies**: Current Phase 3 complete (reactions working)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation:**

1. Open `res://scripts/molecules/Molecule.gd`
2. Update the State enum to add PHOTON_RAIN:

gdscript

```gdscript
   enum State {IDLE, BEING_DRAGGED, IN_WORKSPACE, DESPAWNING, PHOTON_RAIN}
```

3. Add properties for photon rain movement:

gdscript

```gdscript
   var rain_velocity: Vector2 = Vector2.ZERO  # For photon rain movement
```

4. Add new process function after `_process_despawning`:

gdscript

```gdscript
   func _process_photon_rain(delta: float) -> void:
   	# Move photon downward with slope
   	global_position += rain_velocity * delta
   	
   	# Despawn if off bottom of screen
   	if global_position.y > 720 + 50:  # 50px buffer
   		despawn()
```

5. Update the main `_process` function to handle PHOTON_RAIN state:

gdscript

```gdscript
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
   	
   	# Update grab cooldown (existing code...)
```

6. Save script

**Human Checkpoint:**

- [ ]  Script compiles without errors
- [ ]  PHOTON_RAIN state added to enum
- [ ]  rain_velocity property added
- [ ]  _process_photon_rain function implemented
- [ ]  Main _process function handles PHOTON_RAIN case

---

### Task 3.5.2: Modify Photon to Use Rain Behavior

**Dependencies**: Task 3.5.1 (PHOTON_RAIN state exists)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation:**

1. Open `res://scripts/systems/MoleculeSpawner.gd`
2. Modify `spawn_molecule()` to set up photon rain behavior:

gdscript

```gdscript
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
```

3. Save script

**Human Checkpoint:**

- [ ]  Script compiles without errors
- [ ]  Photons spawn with PHOTON_RAIN state
- [ ]  Photons have random slope (-3.0 to 3.0)
- [ ]  Photons marked as can_be_grabbed = false
- [ ]  Other molecules still spawn as IDLE

---

### Task 3.5.3: Add Photon Counter to Workspace

**Dependencies**: Task 3.5.2 (Photons rain down)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation:**

1. Open `res://scripts/systems/Workspace.gd`
2. Add photon tracking properties after existing variables:

gdscript

```gdscript
   var molecules_in_workspace: Array[Molecule] = []
   var photons_collected: int = 0  # Separate photon counter
   var photon_capacity: int = 24  # Photons needed for reaction
   var is_full: bool = false
   var pulse_tween: Tween
```

3. Modify `_on_area_entered` to handle photons differently:

gdscript

```gdscript
   func _on_area_entered(area: Area2D) -> void:
   	if area is Molecule:
   		var molecule = area as Molecule
   		
   		# Handle photons separately - just count them
   		if molecule.molecule_type == Molecule.MoleculeType.PHOTON and molecule.current_state == Molecule.State.PHOTON_RAIN:
   			if photons_collected < photon_capacity:
   				photons_collected += 1
   				# Don't add to molecules_in_workspace array
   				# Photon continues moving through
   			return
   		
   		# Ignore molecules that are being dragged
   		if molecule.current_state == Molecule.State.BEING_DRAGGED:
   			return
   		
   		# Check if workspace is full (existing code...)
   		if molecules_in_workspace.size() >= capacity:
   			if not is_full:
   				is_full = true
   				capacity_reached.emit()
   				update_visual()
   			return
   		
   		# Add to workspace (existing code continues...)
```

4. Add function to get photon count:

gdscript

```gdscript
   func get_photon_count() -> int:
   	return photons_collected
```

5. Add function to remove photons (for reactions):

gdscript

```gdscript
   func remove_photons(count: int) -> void:
   	"""Remove photons after reaction consumes them."""
   	photons_collected = max(0, photons_collected - count)
```

6. Save script

**Human Checkpoint:**

- [ ]  Script compiles without errors
- [ ]  photons_collected counter added
- [ ]  photon_capacity set to 24
- [ ]  Photons counted when passing through workspace
- [ ]  Photons don't add to molecules_in_workspace array
- [ ]  Helper functions added

---

### Task 3.5.4: Update ReactionHandler for Photon Counter

**Dependencies**: Task 3.5.3 (Workspace tracks photons)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation:**

1. Open `res://scripts/systems/ReactionHandler.gd`
2. Modify `_check_photosynthesis()` to use workspace photon counter instead of checking molecules:

gdscript

```gdscript
   func _check_photosynthesis() -> void:
   	"""Check for: 6 CO2 + 6 H2O + 12 photons → glucose + 6 O2."""
   	var co2_count = 0
   	var h2o_count = 0
   	
   	var co2_molecules: Array[Molecule] = []
   	var h2o_molecules: Array[Molecule] = []
   	
   	# Count molecules (excluding photons now - they're tracked separately)
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
   	
   	# Get photon count from workspace
   	var photon_count = workspace.get_photon_count()
   	
   	# Check if requirements met
   	if (co2_count >= GameConstants.PHOTOSYNTHESIS_CO2_NEEDED and
   		h2o_count >= GameConstants.PHOTOSYNTHESIS_H2O_NEEDED and
   		photon_count >= GameConstants.PHOTOSYNTHESIS_PHOTONS_NEEDED):
   		
   		# Collect exact number of molecules needed (no photons in array)
   		var input_molecules: Array[Molecule] = []
   		input_molecules.append_array(co2_molecules.slice(0, GameConstants.PHOTOSYNTHESIS_CO2_NEEDED))
   		input_molecules.append_array(h2o_molecules.slice(0, GameConstants.PHOTOSYNTHESIS_H2O_NEEDED))
   		
   		# Prepare output info
   		var output_info = {
   			"glucose_count": GameConstants.PHOTOSYNTHESIS_GLUCOSE_PRODUCED,
   			"o2_count": GameConstants.PHOTOSYNTHESIS_O2_PRODUCED
   		}
   		
   		# Trigger reaction
   		trigger_reaction(ReactionType.PHOTOSYNTHESIS, input_molecules, output_info)
```

3. Modify `trigger_reaction` to consume photons from workspace:

gdscript

```gdscript
   func trigger_reaction(type: ReactionType, input_molecules: Array[Molecule], output_info: Dictionary) -> void:
   	"""Emit reaction signal and set cooldown."""
   	
   	# Remove molecules from workspace BEFORE animation
   	for molecule in input_molecules:
   		if molecule in workspace.molecules_in_workspace:
   			workspace.molecules_in_workspace.erase(molecule)
   		
   		# Emit despawned signal so spawners can track properly
   		molecule.despawned.emit(molecule)
   	
   	# Remove photons from workspace counter
   	if type == ReactionType.PHOTOSYNTHESIS:
   		workspace.remove_photons(GameConstants.PHOTOSYNTHESIS_PHOTONS_NEEDED)
   	
   	# Update workspace state
   	if workspace.is_full and workspace.molecules_in_workspace.size() < workspace.capacity:
   		workspace.is_full = false
   		workspace.capacity_available.emit()
   		workspace.update_visual()
   	
   	reaction_cooldown = REACTION_COOLDOWN_TIME
   	reaction_triggered.emit(type, input_molecules, output_info)
```

4. Save script

**Human Checkpoint:**

- [ ]  Script compiles without errors
- [ ]  _check_photosynthesis no longer counts photon molecules
- [ ]  Uses workspace.get_photon_count() instead
- [ ]  trigger_reaction removes photons from workspace counter
- [ ]  Reactions trigger with 6 CO2 + 6 H2O + 12 collected photons

---

### Task 3.5.5: Update Debug Label for Photon Count

**Dependencies**: Task 3.5.4 (ReactionHandler uses photon counter)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation:**

1. Open `res://scripts/test/TestSpawner.gd`
2. Update `_process` to show photon count:

gdscript

```gdscript
   func _process(delta: float) -> void:
   	var total = 0
   	total += $PhotonSpawner.active_molecules.size()
   	total += $CO2Spawner.active_molecules.size()
   	total += $H2OSpawner.active_molecules.size()

   	var in_workspace = $Workspace.get_molecule_count()
   	var photons = $Workspace.get_photon_count()
   	
   	# Count each molecule type in workspace (not photons)
   	var co2_count = 0
   	var h2o_count = 0
   	
   	for molecule in $Workspace.molecules_in_workspace:
   		match molecule.molecule_type:
   			Molecule.MoleculeType.CO2:
   				co2_count += 1
   			Molecule.MoleculeType.H2O:
   				h2o_count += 1

   	$DebugLabel.text = "Total: %d | Workspace: %d/28 (CO2:%d H2O:%d) Photons:%d/24 | Reactions: %d" % [
   		total, in_workspace, co2_count, h2o_count, photons, reactions_occurred
   	]

   	if $Workspace.is_at_capacity():
   		$DebugLabel.modulate = Color.RED
   	else:
   		$DebugLabel.modulate = Color.WHITE
```

3. Save script

**Human Checkpoint:**

- [ ]  Script compiles without errors
- [ ]  Debug label shows "Photons: X/24"
- [ ]  Photon count increases as photons pass through workspace
- [ ]  Photon count decreases when reaction occurs
- [ ]  Other molecule counts still display correctly

---

### Task 3.5.6: Test and Balance Photon Rain

**Dependencies**: Task 3.5.5 (All photon rain systems implemented)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation:**

1. Run TestSpawner scene (F6)
2. Observe photon behavior:
	- Do photons rain down at visible speed (~1 second to cross screen)?
	- Do they have varied angles/slopes?
	- Do they pass through workspace and get counted?
	- Can you still drag CO2 and H2O?
	- Can you NOT drag photons?
3. Test reaction:
	- Drag 6 CO2 into workspace
	- Drag 6 H2O into workspace
	- Wait for photons to collect (should reach 12+ quickly)
	- Reaction should trigger automatically
	- Photon count should drop by 12 after reaction
4. Balance adjustments if needed:
	- If photons collect too slowly: Increase PhotonSpawner spawn_rate
	- If too fast: Decrease spawn_rate
	- If angles too extreme: Adjust slope range
	- If speed too fast/slow: Adjust base_speed in spawner

**Human Checkpoint:**

- [ ]  Photons rain down continuously
- [ ]  Photons have varied angles
- [ ]  Photons auto-counted when passing through workspace
- [ ]  Photons cannot be dragged
- [ ]  CO2 and H2O can still be dragged
- [ ]  Reaction triggers with 6 CO2 + 6 H2O + 12 photons collected
- [ ]  Photon count decreases after reaction
- [ ]  Game feels balanced and playable

---

**Summary for Human:** This breaks down the photon rain system into 6 discrete tasks:

1. **3.5.1**: Add PHOTON_RAIN state to Molecule (~15 lines)
2. **3.5.2**: Make photons use rain behavior (~20 lines)
3. **3.5.3**: Add photon counter to Workspace (~30 lines)
4. **3.5.4**: Update ReactionHandler logic (~25 lines)
5. **3.5.5**: Update debug label (~10 lines)
6. **3.5.6**: Test and balance
