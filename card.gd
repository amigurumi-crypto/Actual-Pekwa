extends Node2D


var cardname = "Clubs4"
var suit = 0 # 0Club 1Heart 2Spade 3Diamond
var rank = 4
var cardNumber = 0
var playable = false
var dontGoDownAnymore = false


signal playThis

func _ready():
	self.connect("playThis", get_parent(), "playThis")
#	$Sprite.modulate = Color(0.12549,0.105882, 0.105882)
	$Sprite.modulate = Color.dimgray
#	print($Sprite.modulate)
	wearTexture()
	


func wearTexture():
	$Sprite.texture = load("res://assets/Cards/card" + cardname + ".png")
	if playable:
		$Sprite.modulate = Color(1,1,1)
	

func _on_Control_mouse_entered():
	if !dontGoDownAnymore:
		position += Vector2(0, -20)

func _on_Control_mouse_exited():
	if !dontGoDownAnymore:
		position += Vector2(0, 20)

func _on_Control_gui_input(event):
	if event.is_action_pressed("mouseLeft") and playable:

		emit_signal("playThis", self)
	pass
