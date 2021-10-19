extends Node2D

var tweenDuration = 0.8

var arrayOfCards = []
var displayedCards = []
var player1Hand = []
var player2Hand = []
var player3Hand = []
var player4Hand = []
var played = []

var winOrder = []
var winWords = ["lol", "You", "Left", "Top", "Right"]


onready var hands = ["lol", player1Hand, player2Hand, player3Hand, player4Hand]
onready var spawnPos = ["lol", "lol", $Player2.position, $Player3.position, $Player4.position]
onready var cardsLeft = ["lol", $Player1/Label, $Player2/Label, $Player3/Label, $Player4/Label]

var cardId = 0

var startingCard
var lastToPlay = 0
var lastAction
var humanTurn = false

var cards = preload("res://card.tscn")

var suits = ["Clubs", "Hearts", "Spades", "Diamonds"]

var xPosition = 206
var yPosition = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color.darkgreen)
	randomize()
	$soundFxTimer.wait_time = tweenDuration - 0.1
	makeCards()
	giveCards()
	player1Hand.sort_custom(self, "sort_ascending")
	myCards()
	
	if hands[2].has(startingCard):
		lastToPlay = 2
		playThis(startingCard, player2Hand, true)
	elif hands[3].has(startingCard):
		lastToPlay = 3
		playThis(startingCard, player3Hand, true)
	elif hands[4].has(startingCard):
		lastToPlay = 4
		playThis(startingCard, player4Hand, true)
	else:
		humanTurn = true
	
	
	
		
	



func makeCards():
	for j in range(4):
		for i in range(1,14):
			var piece = cards.instance()
			piece.cardname = suits[j] + str(i)
			piece.suit = j
			piece.rank = i
			if i == 7:
				piece.playable = true
				if j == 3:
					startingCard = piece
			piece.wearTexture()
			piece.cardNumber = cardId
			arrayOfCards.append(piece)
			cardId += 1
	arrayOfCards.shuffle()
	
func giveCards():
	for _i in range(13):
		player1Hand.append(arrayOfCards.pop_front())
		player2Hand.append(arrayOfCards.pop_front())
		player3Hand.append(arrayOfCards.pop_front())
		player4Hand.append(arrayOfCards.pop_front())
		

func myCards():
	var myposition = 64
	for i in player1Hand.size():
		var piece = player1Hand[i]
		add_child(piece)
		piece.position = Vector2(myposition,480)

		myposition += 64

func sort_ascending(a, b):
	if a.cardNumber < b.cardNumber:
		return true
	return false
	
func check_playable(checkthis):
	for k in checkthis.size():
		for l in played.size():
			if abs(checkthis[k].cardNumber - played[l].cardNumber) == 1:
				if checkthis[k].suit == played[l].suit:
					checkthis[k].playable = true
		checkthis[k].wearTexture()
		
func playThis(thing, from = player1Hand, shouldAdd = false):
	if !humanTurn and !shouldAdd:
		return
	thing.z_index = thing.rank
	from.erase(thing)
	played.append(thing)
	if shouldAdd:
		add_child(thing)
		thing.position = spawnPos[lastToPlay]
	else:
		lastToPlay = 1
		humanTurn = false
		$soundFxTimer.start()
		
	thing.dontGoDownAnymore = true
	thing.playable = false
	
	if thing.rank == 1:
		lastAction = "A"
	elif thing.rank == 11:
		lastAction = "J"
	elif thing.rank == 12:
		lastAction = "Q"
	elif thing.rank == 13:
		lastAction = "K"
	else:
		lastAction = str(thing.rank)
	lastAction += " of " + str(suits[thing.suit])
	$Tween.interpolate_property(thing, "position", thing.position, Vector2(224 + 48 * thing.rank, 64 * (thing.suit + 1) + 76), tweenDuration,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(thing, "rotation", thing.rotation, deg2rad(90), tweenDuration,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(thing, "scale", thing.scale, thing.scale/2, tweenDuration,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

	lastToPlay += 1
	
	$Timer.start()
	
func _on_Timer_timeout():
	
	
	if hands[lastToPlay-1].size() == 0:
		lastAction = "Done"
		if !winOrder.has(lastToPlay - 1):
			winOrder.append(lastToPlay - 1)
	
	cardsLeft[lastToPlay-1].text = "Cards left: " + str(hands[lastToPlay-1].size()) + "\nLast played:\n" + lastAction
	
	if played.size() < 52:
		next_player(lastToPlay)
	else:
		displayResults()
	
func next_player(who):
	var didyoupass = true
	if who <= 4:
		check_playable(hands[who])
		for i in hands[who]:
			if i.playable == true:
				playThis(i, hands[who], true)
				didyoupass = false
				break
		if didyoupass:
			lastAction = "Pass"
			lastToPlay += 1
			
			$Timer.start()
		
	elif player1Hand.size() > 0:
		check_playable(hands[1])
		humanTurn = true
	
	else:
		$Timer.wait_time = 0.2
		_on_PassButton_pressed()
		
func displayResults():
	$GameEnd/ResultPanel/Label.text = "1st  place: " + (winWords[winOrder[0]])  + "\n2nd place: " + (winWords[winOrder[1]]) + "\n3rd  place: " + (winWords[winOrder[2]]) + "\n4th  place: " + (winWords[winOrder[3]])
	$GameEnd/ResultPanel.visible = true
	
func _on_PassButton_pressed():
	if lastToPlay == 5:
		lastToPlay = 2
		lastAction = "Pass"
		$Timer.start()

func _on_PauseButton_pressed():
	get_tree().paused = !get_tree().paused
	$Rest/ResultPanel.visible = get_tree().paused

func _on_ResetButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_Resume_pressed():
	get_tree().paused = false
	$Rest/ResultPanel.visible = false

func _on_Home_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Home.tscn")


func _on_soundFxTimer_timeout():
	AudioStuff.play_effects(0)
