extends Node

var soundeffects = [
	preload("res://assets/cardPlace1.ogg"),

]

# Called when the node enters the scene tree for the first time.
func _ready():
	is_playing()

func is_playing():
	if PlayerSaveFile.current_file["bkg_playing"]:
		if $BkgMusicPlayer.playing == true:
			return
		$BkgMusicPlayer.play()
	else:
		$BkgMusicPlayer.stop()

func play_effects(which):
	if PlayerSaveFile.current_file["effects_playing"]:
		$EffectsPlayer.stream = soundeffects[which]
		$EffectsPlayer.play()
