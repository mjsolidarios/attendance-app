
extends TextureButton

var reversed_level = 44;
var current_health = 200;
var current_tardiness = 0;
onready var current_xp = int(get_node("xp_count").get_text())
onready var id = get_node("id-num").get_text()
var name
var xp
var hp
var tp
var lv
var card_loaded = false


func save():
	var savedict = {
#		id = get_node("id-num").get_text(),
#		name = get_node("name").get_text(),
		xp = get_node("xp_count").get_text(),
		hp = get_node("progress-health").get_value(),
		tp = get_node("progress-tardiness").get_value(),
		lv = get_node("level").get_text()
	}
	return savedict

func write_save_to_file(filename):
	var savegame = File.new()
	savegame.open("user://"+filename+".save", File.WRITE)
	var nodedata = save()
	savegame.store_line(nodedata.to_json())
	savegame.close()

func save_card():
	var filename = id.md5_text()
	write_save_to_file(filename)


func can_drop_data(pos, data):
	return typeof(data) == TYPE_ARRAY

func set_progress(data):
	var curr_val_health = get_node("progress-health").get_value()
	var curr_val_tardiness = get_node("progress-tardiness").get_value()
	get_node("progress-health").set_value(curr_val_health + data[0])
	get_node("progress-tardiness").set_value(curr_val_tardiness + data[1])
	save_card()
	
func drop_data(pos, data):	
	set_progress(data)

func set_xp(value):
	current_xp = int(value)
	if(current_xp > 44):
		current_xp = 44
	var max_xp = 44
	get_node("xp_count").set_text(str(value))
	var res = load("res://assets/hud-progress-circular/"+str(abs(max_xp-current_xp))+".png")
	get_node("current-level").set_texture(res)

func _update_xp(index):
	var current_level = int(get_node("level").get_text())
	if(current_xp == 44):
		current_xp = 0
	if (reversed_level != 0):
		reversed_level-=int(index)
		current_xp += 1
	else:
		reversed_level = 44
		current_level += 1
	# print(str(abs(reversed_level)))
	var res = load("res://assets/hud-progress-circular/"+str(abs(reversed_level))+".png")
	get_node("current-level").set_texture(res)
	get_node("level").set_text(str(current_level))
	get_node("xp_count").set_text(str(current_xp))

func gain_xp():
	_update_xp(1)
	save_card()

var options_open = false;
func toggle_options():
	if(options_open):
		get_node("ui_animation").play("hide_options")
		options_open = false
	else:
		get_node("ui_animation").play("show_options")
		options_open = true

func load_card_data(filename):
	print("Card data loaded.")
	var savedata = File.new()
	var path = "user://"+filename+".save"
	if !savedata.file_exists(path):
	#print("File nonexistent on path: "+path)
		return
	var currentline = {}
	savedata.open(path, File.READ)
	while (!savedata.eof_reached()):
		currentline.parse_json(savedata.get_line())
		set_xp(currentline["xp"])
		get_node("progress-health").set_value(currentline["hp"])
		get_node("progress-tardiness").set_value(currentline["tp"])
		get_node("level").set_text(currentline["lv"])
	savedata.close()

func _process(delta):
	var sentinel = get_node("id-num").get_text()
	if(sentinel=="0"):
		print("card not loaded -> "+ sentinel )
	else:
		if(card_loaded==false):
			load_card_data(id.md5_text())
			card_loaded = true
	
func _fixed_process(delta):
	var sentinel = get_node("id-num").get_text()
	if(sentinel=="0"):
		print("card not loaded -> "+ sentinel )
	else:
		if(card_loaded==false):
			load_card_data(id.md5_text())
			card_loaded = true

func _ready():
	get_node("ButtonLevelUp").connect("pressed",self,"gain_xp")
	get_node("more_options").connect("pressed",self,"toggle_options")
	set_process(true)

