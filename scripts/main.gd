
extends Node2D

var content

func set_text(val):
	get_node("Label").set_text(val)

func save():
	var savedict = {
		content = get_node("LineEdit").get_text()
	}
	return savedict

func save_game():
	save_manager.save_game()


func _instance():
	var container = get_node("CardView/ScrollContainer/HBoxContainer")
	var children = get_node("CardView/ScrollContainer/HBoxContainer").get_child_count()
	# remove last empty child
	var last_child = container.get_child(children-1)
	container.remove_child(last_child)
	var card_scene = load("res://scenes/card.scn")
	var card_node = card_scene.instance()
	var control_node = Control.new()
	var empty_control = Control.new()
	control_node.add_child(card_node)
	container.add_child(control_node)
	container.add_child(empty_control)
	
func load_game():
	var savegame = File.new()
	if !savegame.file_exists("user://savegame.save"):
		return #Error!  We don't have a save to load
	# We need to revert the game state so we're not cloning objects during loading.  This will vary wildly depending on the needs of a project, so take care with this step.
	# For our example, we will accomplish this by deleting savable objects.
#	var savenodes = get_tree().get_nodes_in_group("Persist")
#	for i in savenodes:
#		i.queue_free()
	# Load the file line by line and process that dictionary to restore the object it represents
	var currentline = {} # dict.parse_json() requires a declared dict.
	savegame.open("user://savegame.save", File.READ)
	while (!savegame.eof_reached()):
		currentline.parse_json(savegame.get_line())
		set_text(currentline["content"])
	savegame.close()

