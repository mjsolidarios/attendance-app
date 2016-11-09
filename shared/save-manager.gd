
extends Node

func save_game(filename):
	var savegame = File.new()
	savegame.open("user://"+filename+".save", File.WRITE)
	var savenodes = get_tree().get_nodes_in_group("Persist")
	for i in savenodes:
		var nodedata = i.save()
		savegame.store_line(nodedata.to_json())
	savegame.close()


