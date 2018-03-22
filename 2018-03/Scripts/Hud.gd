extends Control


enum ModeType { SCORE, TIME, DATE }

export(ModeType) var mode setget SetMode, GetMode

var score = 0 setget SetScore, GetScore
var miss = 0 setget SetMiss, GetMiss

const digitSprites = [ 
	preload("res://Sprites/Digits/digit_0.png"),
	preload("res://Sprites/Digits/digit_1.png"),
	preload("res://Sprites/Digits/digit_2.png"),
	preload("res://Sprites/Digits/digit_3.png"),
	preload("res://Sprites/Digits/digit_4.png"),
	preload("res://Sprites/Digits/digit_5.png"),
	preload("res://Sprites/Digits/digit_6.png"),
	preload("res://Sprites/Digits/digit_7.png"),
	preload("res://Sprites/Digits/digit_8.png"),
	preload("res://Sprites/Digits/digit_9.png")
]


func _ready():
	set_process(false)
	#set_process_input(false)
	pass


# Test code
func _input(event):
	if event.is_action_pressed("ui_select"):
		if mode == ModeType.TIME:
			SetMode(ModeType.DATE)
		elif mode == ModeType.DATE:
			SetMode(ModeType.SCORE)
		else:
			SetMode(ModeType.TIME)


func _process(delta):
	var currentTime = OS.get_time()
	var hour = currentTime["hour"]
	if hour > 12:
		hour = hour - 12
		$DigitContainer/TimeMarker/Am.modulate = Color(1, 1, 1, 0)
		$DigitContainer/TimeMarker/Pm.modulate = Color(1, 1, 1, 1)
	else:
		$DigitContainer/TimeMarker/Am.modulate = Color(1, 1, 1, 1)
		$DigitContainer/TimeMarker/Pm.modulate = Color(1, 1, 1, 0)
	var hourDigits = GetDigits(hour, 2)
	var minuteDigits = GetDigits(currentTime["minute"], 2)
	
	$DigitContainer/HourDigits/Digit01.texture = digitSprites[hourDigits[0]]
	$DigitContainer/HourDigits/Digit02.texture = digitSprites[hourDigits[1]]
	$DigitContainer/MinuteDigits/Digit03.texture = digitSprites[minuteDigits[0]]
	$DigitContainer/MinuteDigits/Digit04.texture = digitSprites[minuteDigits[1]]


func SetMode(value):
	if value == null:
		return

	mode = value
	if mode == ModeType.TIME:
		$DigitContainer/TimeMarker.modulate = Color(1, 1, 1, 1)
		$AnimationPlayer.play("seconds")
		set_process(true)
		return
	
	$AnimationPlayer.stop(true)
	$DigitContainer/Colon.modulate = Color(1, 1, 1, 0)
	$DigitContainer/TimeMarker.modulate = Color(1, 1, 1, 0)
	set_process(false)
	
	if mode == ModeType.SCORE:
		SetScore(score)
	
	if mode == ModeType.DATE:
		var currentDate = OS.get_date()
		var monthDigits = GetDigits(currentDate["month"], 2)
		var dayDigits = GetDigits(currentDate["day"], 2)
		
		$DigitContainer/HourDigits/Digit01.texture = digitSprites[monthDigits[0]]
		$DigitContainer/HourDigits/Digit02.texture = digitSprites[monthDigits[1]]
		$DigitContainer/MinuteDigits/Digit03.texture = digitSprites[dayDigits[0]]
		$DigitContainer/MinuteDigits/Digit04.texture = digitSprites[dayDigits[1]]


func GetMode():
	return mode


func SetScore(value):
	score = value
	print(score)
	if mode != ModeType.SCORE:
		print("no update")
		return
	
	var digits = GetDigits(score, 4)
	
	$DigitContainer/HourDigits/Digit01.texture = digitSprites[digits[0]]
	$DigitContainer/HourDigits/Digit02.texture = digitSprites[digits[1]]
	$DigitContainer/MinuteDigits/Digit03.texture = digitSprites[digits[2]]
	$DigitContainer/MinuteDigits/Digit04.texture = digitSprites[digits[3]]


func GetScore():
	return score


func GetDigits(number, pad):
	var strNumber = str(number)
	var digits = []
	
	for i in range(strNumber.length()):
		digits.append(strNumber[i].to_int())
	
	while digits.size() < pad:
		digits.insert(0, 0)
	
	return digits


func SetMiss(value):
	miss = value
	$Miss/Value.text = str(miss)


func GetMiss():
	return miss



