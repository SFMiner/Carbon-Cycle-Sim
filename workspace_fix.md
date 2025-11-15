## Task 2.9.1: Workspace Continuous Molecule Detection

**Dependencies**: Task 2.9 (Workspace with BEING_DRAGGED check)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:

1. Open `res://scripts/systems/Workspace.gd`
2. Add a `_process()` function after `_ready()` (around line 34):

gdscript

```gdscript
   func _process(delta: float) -> void:
   	check_for_dropped_molecules()
```

3. Add the new detection function at the end of the script (before `pulse_reaction`):

gdscript

```gdscript
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
```

4. Use tabs for indentation
5. Save script

**Human Checkpoint**:

- [ ]  Script compiles without errors
- [ ]  `_process()` function added after `_ready()`
- [ ]  `check_for_dropped_molecules()` function added before `pulse_reaction()`
- [ ]  All indentation uses tabs
- [ ]  Type hints present (`: void`)

---

## Task 2.9.2: Test Dropped Molecule Detection

**Dependencies**: Task 2.9.1 (Workspace continuous detection)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:

1. Run `res://scenes/test/TestSpawner.tscn` (F6)
2. Test basic functionality:
	- Drag 1 molecule into workspace
	- Drop it inside the green circle
	- Watch debug label
3. Expected behavior:
	- Debug label should show "In Workspace: 1/20"
	- Molecule should NOT despawn after 5 seconds
	- Molecule should stay inside workspace
4. Test multiple molecules:
	- Drag and drop 5 molecules inside
	- Debug label should show "In Workspace: 5/20"
	- All molecules should persist (not despawn)
5. Test capacity:
	- Drag and drop 20 molecules inside
	- Debug label should show "In Workspace: 20/20"
	- Debug label should turn red
	- Border should turn red
	- Try dropping 21st molecule - should NOT be added

**Human Checkpoint**:

- [ ]  Scene runs without errors
- [ ]  Dropping molecules inside increments counter
- [ ]  Molecules inside workspace do NOT despawn
- [ ]  Counter shows correct "X/20" value
- [ ]  At 20 molecules, border turns red
- [ ]  At 20 molecules, label turns red
- [ ]  21st molecule dropped inside is rejected (stays at 20)
- [ ]  Console prints "Workspace is full!" at 20

---

## Task 2.9.3: Test Edge Cases

**Dependencies**: Task 2.9.2 (Basic detection works)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:

1. Run `res://scenes/test/TestSpawner.tscn` (F6)
2. Test dragging molecules OUT of workspace:
	- Drop 5 molecules inside workspace
	- Verify counter shows 5
	- Pick up 1 molecule and drag it outside
	- Drop it outside the workspace
	- Expected: Counter should decrease to 4
3. Test dragging THROUGH workspace:
	- Start dragging a molecule from outside
	- Drag it through the workspace (don't drop)
    - Drag it out the other side
    - Expected: Counter should NOT increase
4. Test molecules stuck at border (from before):
    - Verify this no longer happens
    - Molecules should follow mouse smoothly across border
5. Test rapid drops:
    - Quickly drag and drop 10 molecules inside
    - Expected: All 10 should be counted correctly

**Human Checkpoint**:

- [ ]  Dragging molecules out decreases counter
- [ ]  Dragging through (without dropping) doesn't affect counter
- [ ]  No molecules stuck at border
- [ ]  Rapid drops all counted correctly
- [ ]  Workspace tracking accurate in all cases

---

## Task 2.9.4: Verify State Transitions

**Dependencies**: Task 2.9.3 (Edge cases work)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:

1. Add temporary debug prints to verify states
2. Open `res://scripts/systems/Workspace.gd`
3. Modify `check_for_dropped_molecules()` to add debug output:

gdscript

```gdscript
   # Only process IDLE molecules not already tracked
   if molecule.current_state == Molecule.State.IDLE and molecule not in molecules_in_workspace:
   	print("Adding molecule to workspace. State: ", molecule.current_state)
   	# Add to workspace
   	molecules_in_workspace.append(molecule)
   	molecule.current_state = Molecule.State.IN_WORKSPACE
   	print("Changed molecule state to IN_WORKSPACE")
   	molecule_entered.emit(molecule)
```

4. Run scene and drop a molecule inside
5. Check console output:
	- Should see: "Adding molecule to workspace. State: 0" (IDLE = 0)
	- Should see: "Changed molecule state to IN_WORKSPACE"
6. After verifying, REMOVE the debug print statements

**Human Checkpoint**:

- [ ]  Console shows correct state transitions
- [ ]  Molecules change from IDLE (0) to IN_WORKSPACE (2)
- [ ]  No error messages in console
- [ ]  Debug prints removed after verification

---

**Summary for Human:** This breaks down the fix into 4 discrete tasks:

1. **2.9.1**: Add the continuous detection code (~20 lines)
2. **2.9.2**: Test basic functionality (drop and count)
3. **2.9.3**: Test edge cases (drag out, drag through, rapid drops)
4. **2.9.4**: Verify state transitions with debug prints

Each task has clear checkpoints and is suitable for Haiku 4.5's processing capacity. Start with 2.9.1 and proceed sequentially.
