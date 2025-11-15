## Task 3.3.1: Fix Molecule Cleanup After Reaction

**In `res://scripts/systems/ReactionHandler.gd`**, modify the `trigger_reaction` function:

gdscript

```gdscript
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
```

## Task 3.3.2: Improve Debug Label

**In `res://scripts/test/TestSpawner.gd`**, modify the `_process` function:

gdscript

```gdscript
func _process(delta: float) -> void:
	var total = 0
	total += $PhotonSpawner.active_molecules.size()
	total += $CO2Spawner.active_molecules.size()
	total += $H2OSpawner.active_molecules.size()

	var in_workspace = $Workspace.get_molecule_count()
	
	# Count each type in workspace
	var co2_count = 0
	var h2o_count = 0
	var photon_count = 0
	
	for molecule in $Workspace.molecules_in_workspace:
		match molecule.molecule_type:
			Molecule.MoleculeType.CO2:
				co2_count += 1
			Molecule.MoleculeType.H2O:
				h2o_count += 1
			Molecule.MoleculeType.PHOTON:
				photon_count += 1

	$DebugLabel.text = "Total: %d | Workspace: %d/28 (CO2:%d H2O:%d Photons:%d) | Reactions: %d" % [
		total, in_workspace, co2_count, h2o_count, photon_count, reactions_occurred
	]

	if $Workspace.is_at_capacity():
		$DebugLabel.modulate = Color.RED
	else:
		$DebugLabel.modulate = Color.WHITE
```
