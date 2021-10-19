extends Node2D

export (Texture) var musicOn
export (Texture) var musicOff
export (Texture) var soundsOn
export (Texture) var soundsOff


# Called when the node enters the scene tree for the first time.
func _ready():
	change_textures()
	VisualServer.set_default_clear_color(Color.darkolivegreen)

func _on_Button_pressed():
	get_tree().change_scene("res://main.tscn")


func _on_Music_pressed():
	PlayerSaveFile.current_file["bkg_playing"] = !PlayerSaveFile.current_file["bkg_playing"]
	AudioStuff.is_playing()
	change_textures()

func _on_Sounds_pressed():
	PlayerSaveFile.current_file["effects_playing"] = !PlayerSaveFile.current_file["effects_playing"]
	change_textures()

func change_textures():
	if PlayerSaveFile.current_file["bkg_playing"]:
		$TextureRect/Music.texture_normal = musicOn
	else:
		$TextureRect/Music.texture_normal = musicOff
	if PlayerSaveFile.current_file["effects_playing"]:
		$TextureRect/Sounds.texture_normal = soundsOn
	else:
		$TextureRect/Sounds.texture_normal = soundsOff
	PlayerSaveFile.save_data_to_file()
	

func _on_Credits_pressed():
	$TextureRect/PopupPanel.show()



func _on_Stats_pressed():
	pass # Replace with function body.


func _on_Shop_pressed():
	pass # Replace with function body.
