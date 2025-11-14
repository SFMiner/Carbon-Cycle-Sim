extends Node

# Photosynthesis requirements
const PHOTOSYNTHESIS_CO2_NEEDED: int = 6
const PHOTOSYNTHESIS_H2O_NEEDED: int = 6
const PHOTOSYNTHESIS_PHOTONS_NEEDED: int = 12
const PHOTOSYNTHESIS_O2_PRODUCED: int = 6
const PHOTOSYNTHESIS_GLUCOSE_PRODUCED: int = 1

# Respiration requirements
const RESPIRATION_GLUCOSE_NEEDED: int = 1
const RESPIRATION_O2_NEEDED: int = 6
const RESPIRATION_CO2_PRODUCED: int = 6
const RESPIRATION_H2O_PRODUCED: int = 6
const RESPIRATION_ATP_PRODUCED: int = 3

# Workspace Capacities
const STAGE1_WORKSPACE_CAPACITY: int = 20
const STAGE2_WORKSPACE_CAPACITY: int = 15
const WORKSPACE_RADIUS_STAGE1: int = 300  # pixels
const WORKSPACE_WIDTH_STAGE2: int = 400   # pixels
const WORKSPACE_HEIGHT_STAGE2: int = 250  # pixels

# Molecule Spawn Rates
const PHOTON_SPAWN_RATE: float = 2.0  # per second
const CO2_SPAWN_RATE_STAGE1: float = 3.0  # per second
const H2O_SPAWN_RATE: float = 3.0  # per second
const GLUCOSE_SPAWN_RATE: float = 0.5  # per 2 seconds
const O2_SPAWN_RATE_STAGE2: float = 4.0  # per second
const MAX_MOLECULES_STAGE1: int = 30
const MAX_MOLECULES_STAGE2: int = 25
const MOLECULE_DESPAWN_TIME: float = 5.0  # seconds

# Spawn Positions - Stage 1 spawn zones
const PHOTON_SPAWN_X_MIN: int = 400
const PHOTON_SPAWN_X_MAX: int = 880
const PHOTON_SPAWN_Y: int = 0
const CO2_SPAWN_X: int = 0
const CO2_SPAWN_Y_MIN: int = 200
const CO2_SPAWN_Y_MAX: int = 520
const H2O_SPAWN_X_MIN: int = 400
const H2O_SPAWN_X_MAX: int = 880
const H2O_SPAWN_Y: int = 720
const SPAWN_OFFSET_RANGE: int = 20  # +/- random offset

# Spawn Positions - Stage 2 spawn zones
const GLUCOSE_SPAWN_X: int = 0
const GLUCOSE_SPAWN_Y_MIN: int = 300
const GLUCOSE_SPAWN_Y_MAX: int = 420
const O2_SPAWN_X: int = 1280
const O2_SPAWN_Y_MIN: int = 200
const O2_SPAWN_Y_MAX: int = 520

# Workspace Centers (calculated)
const WORKSPACE_CENTER_X: int = 640  # 1280 / 2
const WORKSPACE_CENTER_Y: int = 360  # 720 / 2

# Trash Zone
const TRASH_ZONE_X_MIN: int = 1100
const TRASH_ZONE_X_MAX: int = 1280
const TRASH_ZONE_Y_MIN: int = 600
const TRASH_ZONE_Y_MAX: int = 720

# Stage 3 Atmosphere - Gas pools
const ATMOSPHERE_MIN: int = 0
const ATMOSPHERE_MAX: int = 200
const ATMOSPHERE_INITIAL_CO2: int = 100
const ATMOSPHERE_INITIAL_O2: int = 100
const ATMOSPHERE_BALANCED_MIN: int = 50
const ATMOSPHERE_BALANCED_MAX: int = 150
const ATMOSPHERE_RECOVERY_THRESHOLD_LOW: int = 20
const ATMOSPHERE_RECOVERY_THRESHOLD_HIGH: int = 180
const ATMOSPHERE_RECOVERY_RATE: int = 2  # per tick

# Organism parameters
const PLANT_CO2_CONSUMPTION: int = 5  # per tick
const PLANT_O2_PRODUCTION: int = 5    # per tick
const ANIMAL_O2_CONSUMPTION: int = 3  # per tick
const ANIMAL_CO2_PRODUCTION: int = 3  # per tick
const ORGANISM_MAX_PLANTS: int = 10
const ORGANISM_MAX_ANIMALS: int = 10
const INITIAL_PLANTS: int = 3
const INITIAL_ANIMALS: int = 3
const ADD_BUTTON_COOLDOWN: float = 0.5  # seconds

# Tick rate
const TICK_RATE: float = 1.0  # seconds per tick

# Balance timer
const BALANCE_TIME_GOAL: float = 120.0  # seconds

# Animation Timings
const REACTION_SWIRL_DURATION: float = 0.8  # seconds
const REACTION_SCALE_DURATION: float = 0.3  # seconds
const O2_DRIFT_DURATION: float = 2.0  # seconds
const GLUCOSE_SHATTER_DURATION: float = 0.6  # seconds
const ATP_BOLT_DURATION: float = 0.5  # seconds
const ATP_BOLT_LENGTH: int = 128  # pixels
const DELETION_ANIMATION_DURATION: float = 0.3  # seconds
const STAGE_TRANSITION_FADE: float = 0.5  # seconds

# Molecule Behavior
const MOLECULE_COLLISION_RADIUS: int = 32  # pixels
const MOLECULE_SEPARATION_FORCE: float = 10.0  # pixels per second
const MOLECULE_DRAG_COOLDOWN: float = 0.2  # seconds after release

# Color Constants
const COLOR_SKY: Color = Color("#87CEEB")
const COLOR_SOIL: Color = Color("#8B4513")
const COLOR_SUN: Color = Color("#FFD700")
const COLOR_PHOTON: Color = Color("#FFFF00")
const COLOR_CO2_BASE: Color = Color("#808080")
const COLOR_CO2_DOTS: Color = Color("#FF0000")
const COLOR_H2O_BASE: Color = Color("#FF0000")
const COLOR_H2O_DOTS: Color = Color("#FFFFFF")
const COLOR_O2: Color = Color("#FF0000")
const COLOR_GLUCOSE: Color = Color("#DAA520")
const COLOR_CHLOROPLAST: Color = Color("#90EE90")
const COLOR_MITOCHONDRIA: Color = Color("#FFB347")
const COLOR_PLANT: Color = Color("#228B22")
const COLOR_ANIMAL: Color = Color("#8B4513")

# Stage Target Goals
const STAGE1_GLUCOSE_TARGET: int = 5
const STAGE2_GLUCOSE_TARGET: int = 5
