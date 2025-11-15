### Task 3.5.7: Absorb Collected Photons

**Dependencies**: Task 3.5.6 (Photon rain working)  
**Extended thinking**: OFF

**Implementation:**

1. Open `res://scripts/systems/Workspace.gd`
2. Modify the photon handling in `_on_area_entered`:

gdscript

```gdscript
   # Handle photons separately - count and absorb them
   if molecule.molecule_type == Molecule.MoleculeType.PHOTON and molecule.current_state == Molecule.State.PHOTON_RAIN:
   	if photons_collected < photon_capacity:
   		photons_collected += 1
   		# Absorb the photon - change to despawning state
   		molecule.current_state = Molecule.State.DESPAWNING
   		# Don't add to molecules_in_workspace array
   	return
```

3. Save script

**Human Checkpoint:**

- [ ]  Photons stop moving when they enter workspace
- [ ]  Photons still get counted
- [ ]  Photons disappear (despawn)

---

### Task 3.5.8: Add Fade Effect to Photon Absorption

**Dependencies**: Task 3.5.7 (Photons stop when absorbed)  
**Extended thinking**: OFF

**Implementation:**

1. Open `res://scripts/molecules/Molecule.gd`
2. Add fade tracking variable with other properties:

gdscript

```gdscript
   var time_since_spawn: float = 0.0
   var despawn_timer: float = 0.0  # Track time in despawning state
   var can_be_grabbed: bool = true
   var grab_cooldown_timer: float = 0.0
```

3. Update `_process_despawning` to add fade effect:

gdscript

```gdscript
   func _process_despawning(delta: float) -> void:
   	despawn_timer += delta
   	
   	# Fade out over 0.3 seconds
   	var fade_duration = 0.3
   	if despawn_timer < fade_duration:
   		var alpha = 1.0 - (despawn_timer / fade_duration)
   		modulate.a = alpha
   	else:
   		# Fade complete, remove molecule
   		queue_free()
```

4. Update `despawn()` function to reset timer:

gdscript

```gdscript
   func despawn() -> void:
   	current_state = State.DESPAWNING
   	despawn_timer = 0.0  # Reset timer for fade
   	despawned.emit(self)
```

5. Save script

**Human Checkpoint:**

- [ ]  Photons fade out smoothly over 0.3 seconds when absorbed
- [ ]  Fade looks natural (not abrupt)
- [ ]  Other molecules still behave normally
- [ ]  Reactions still trigger correctly
