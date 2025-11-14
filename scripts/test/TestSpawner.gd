extends Node2D

var molecules_deleted: int = 0


func _ready() -> void:
	$Workspace.capacity_reached.connect(_on_workspace_full)
	$Workspace.capacity_available.connect(_on_workspace_available)
	$TrashZone.molecule_deleted.connect(_on_molecule_deleted)


func _process(delta: float) -> void:
	var total = 0
	total += $PhotonSpawner.active_molecules.size()
	total += $CO2Spawner.active_molecules.size()
	total += $H2OSpawner.active_molecules.size()

	var in_workspace = $Workspace.get_molecule_count()

	$DebugLabel.text = "Total: %d | In Workspace: %d/20 | Deleted: %d" % [total, in_workspace, molecules_deleted]

	if $Workspace.is_at_capacity():
		$DebugLabel.modulate = Color.RED
	else:
		$DebugLabel.modulate = Color.WHITE


func _on_workspace_full() -> void:
	print("Workspace is full!")


func _on_workspace_available() -> void:
	print("Workspace has space available")


func _on_molecule_deleted(molecule: Molecule) -> void:
	molecules_deleted += 1
	print("Molecule deleted! Total: ", molecules_deleted)
