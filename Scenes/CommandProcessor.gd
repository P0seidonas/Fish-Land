extends Node


signal response_generated(response_text)

var current_room = null




func initialize(starting_room):
	change_room(starting_room)


func process_command(input: String) -> String:
	var words = input.split(" ", false)
	if words.size() == 0:
		return "Error: no words were parsed."
		
	var first_word = words[0].to_lower()
	var second_word = ""
	if words.size() > 1:
		second_word = words[1].to_lower()
	
	match first_word:
		"go":
			return go(second_word)
		"help":
			return help()
		_:
			return "Command not recognized - please try again."

func go(second_word: String) -> String:
	if second_word == "":
		return "Go where?"
	
	return "You go %s" % second_word
	
func help() -> String:
	return "You can use these commands: go [location], help"
	
func change_room(new_room: Room):
	current_room = new_room
	emit_signal("response_generated", "You go to " + new_room.room_name)
	emit_signal("response_generated", new_room.room_description)
