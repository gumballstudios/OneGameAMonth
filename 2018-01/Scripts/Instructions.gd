extends Node2D


const instruction_text = [
	"Form a school of fish by clicking on a group of 3 or more of the same colored fish to help them escape the hungry sharks.  The more fish in the school the more points you earn.",
	"Blowfish will appear after rescuing a set amount of fish.  Clicking on a blowfish will cause all the fish around it to escape.  If another blowfish is within its radius it will also be triggered.",
	"New columns of fish will enter from the left side of the screen.  Their arrivial speed will increase the longer you survive.",
	"If the new column of fish pushes any fish off the right side of the screen the sharks will attack and then game will be over."
]

var current_frame = 0


func _ready():
	display_frame()


func display_frame():
	var text = get_node("Frame/Label")
	text.set_text(instruction_text[current_frame])
	
	var accent_list = get_node("Frame/Accents")
	for accent in accent_list.get_children():
		accent.hide()
	
	accent_list.get_child(current_frame).show()
	
	get_node("Frame/Previous").set_hidden(current_frame == 0)
	get_node("Frame/Next").set_hidden(current_frame == (instruction_text.size() - 1))


func _on_previous_pressed():
	get_node("SoundEffects").play("help_flip")
	current_frame -= 1
	display_frame()


func _on_next_pressed():
	get_node("SoundEffects").play("help_flip")
	current_frame += 1
	display_frame()


func _on_exit_pressed():
	get_node("SoundEffects").play("help_close")
	hide()
	current_frame = 0
	display_frame()
