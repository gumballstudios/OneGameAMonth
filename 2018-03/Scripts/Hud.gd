extends Control


var score = 0 setget SetScore, GetScore
var miss = 0 setget SetMiss, GetMiss

const digit_sprites = [ 
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
	pass


func SetScore(value):
	score = value
	var digits = GetDigits(score)
	
	$DigitContainer/HourDigits/Digit01.texture = digit_sprites[digits[0]]
	$DigitContainer/HourDigits/Digit02.texture = digit_sprites[digits[1]]
	$DigitContainer/MinuteDigits/Digit03.texture = digit_sprites[digits[2]]
	$DigitContainer/MinuteDigits/Digit04.texture = digit_sprites[digits[3]]


func GetScore():
	return score


func GetDigits(number):
	var strNumber = str(number)
	var digits = []
	
	for i in range(strNumber.length()):
		digits.append(strNumber[i].to_int())
	
	while digits.size() < 4:
		digits.insert(0, 0)
	
	return digits


func SetMiss(value):
	miss = value
	$Miss/Value.text = str(miss)


func GetMiss():
	return miss

