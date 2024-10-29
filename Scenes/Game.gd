extends Control

const Response = preload("res://Scenes/response.tscn")
const InputResponse = preload("res://Scenes/input_response.tscn")

@onready var command_proccesor = $CommandProcessor
@onready var history_rows = $RoomManager/MenuRoom/MarginContainer/VBucks/GameInfo/Scroll/HistoryRows
@onready var scroll = $RoomManager/MenuRoom/MarginContainer/VBucks/GameInfo/Scroll
@onready var scrollbar = scroll.get_v_scroll_bar()
@export var max_lines_remebered :int = 30
@onready var room_manager = $RoomManager

func _ready():
	scrollbar.changed.connect(handle_scrollbar_changed)
	
	handle_response_generated("Welcome to the land of fishing!")
	
	command_proccesor.response_generated.connect(handle_response_generated)
	command_proccesor.initialize(room_manager.get_child(0))


func handle_scrollbar_changed():
	scroll.scroll_vertical = scrollbar.max_value


func handle_response_generated(response_text: String):
	var response = Response.instantiate()
	response.text = response_text
	add_response_to_game(response)



func _on_input_text_submitted(new_text):
	if new_text.is_empty():
		return
	
	var input_response = InputResponse.instantiate()
	var response = command_proccesor.process_command(new_text)
	input_response.set_text(new_text, response)
	add_response_to_game(input_response)
	change_room_level(new_text)

func add_response_to_game(response: Control):
	history_rows.add_child(response)
	delete_history_beyond_limit()
	
			
func delete_history_beyond_limit():
	if history_rows.get_child_count() > max_lines_remebered:
		var rows_to_forget = history_rows.get_child_count() - max_lines_remebered
		for i in range(rows_to_forget):
			history_rows.get_child(i).queue_free()
			
func change_room_level(input_response: String):
	match input_response:
		"go pond":
			command_proccesor.initialize(room_manager.get_child(1))
		"exit":
			get_tree().quit()
		"menu":
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")
