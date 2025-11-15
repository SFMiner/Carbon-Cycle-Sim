extends Node
class_name AudioSoundManager

# Sound effect players
var sfx_players: Array[AudioStreamPlayer] = []
var sfx_pool_size: int = 8

# Sound types (using simple sine tones for placeholders)
enum SoundType {
	MOLECULE_PICKUP,
	MOLECULE_DROP,
	REACTION_PHOTOSYNTHESIS,
	REACTION_RESPIRATION,
	WORKSPACE_FULL,
	DELETE
}

func _ready() -> void:
	# Create pool of audio players
	for i in range(sfx_pool_size):
		var player = AudioStreamPlayer.new()
		add_child(player)
		player.bus = "SFX"
		sfx_players.append(player)


func play_sound(sound_type: SoundType) -> void:
	"""Play a sound effect (placeholder)."""
	match sound_type:
		SoundType.MOLECULE_PICKUP:
			print("🔊 Boop!")
		SoundType.MOLECULE_DROP:
			print("🔊 Click!")
		SoundType.REACTION_PHOTOSYNTHESIS:
			print("🔊 Chime! ✨")
		SoundType.REACTION_RESPIRATION:
			print("🔊 Whoosh! 💨")
		SoundType.WORKSPACE_FULL:
			print("🔊 Buzz!")
		SoundType.DELETE:
			print("🔊 Pop!")

	# TODO: Replace with actual sound playback when audio files sourced


func get_available_player() -> AudioStreamPlayer:
	"""Find a player that's not currently playing."""
	for player in sfx_players:
		if not player.playing:
			return player
	return sfx_players[0]  # Fallback to first player
