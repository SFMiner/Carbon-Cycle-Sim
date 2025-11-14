extends Line2D
class_name ATPBolt

var lifetime: float = 0.0
var max_lifetime: float = GameConstants.ATP_BOLT_DURATION


func _ready() -> void:
	# Configure line appearance
	width = 5
	default_color = Color.YELLOW
	antialiased = true

	# Create lightning bolt shape
	points = generate_bolt_points()


func _process(delta: float) -> void:
	lifetime += delta

	# Fade out
	var alpha = 1.0 - (lifetime / max_lifetime)
	default_color = Color(1, 1, 0, alpha)  # Yellow with fading alpha

	# Delete when done
	if lifetime >= max_lifetime:
		queue_free()


func generate_bolt_points() -> PackedVector2Array:
	"""Generate lightning bolt line points."""
	var pts: PackedVector2Array = []
	var length = GameConstants.ATP_BOLT_LENGTH

	# Start at origin
	pts.append(Vector2.ZERO)

	# Create zigzag pattern
	var segments = 4
	for i in range(segments):
		var progress = float(i + 1) / segments
		var base_pos = Vector2(length * progress, 0)

		# Add random offset perpendicular to direction
		var offset = Vector2(0, randf_range(-20, 20))
		pts.append(base_pos + offset)

	return pts


func set_direction(angle_degrees: float) -> void:
	"""Rotate the bolt to point in a direction."""
	rotation_degrees = angle_degrees
