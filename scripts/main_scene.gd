
extends Node2D

var active_panel = "info"

func _free_card_nodes():
	var container = get_node("cards_view/container/control").get_children()
	for i in container:
        i.queue_free()

func _load_card_data(target):
	#free existing nodes
	_free_card_nodes()
	var data_source
	if(target=="a"):
		data_source = student_data.bsit_3st_it242
	if(target=="b"):
		data_source = student_data.bsis_2bad_is222
	if(target=="c"):
		data_source = student_data.bsis_2a_it204a
	if(target=="e"):
		data_source = student_data.bsit_3b_it248
	if(target=="demo"):
		data_source = student_data.demo
	for key in data_source:
		_instance(data_source[key][0],data_source[key][1],data_source[key][2])

func _show_welcome(mode):
	get_node("welcome_animation").play("show")
	if(mode=="animate"):
		get_node("welcome/animation_player").play("logo-fx")

func _hide_welcome():
	get_node("welcome_animation").play("hide")
	get_node("welcome/animation_player").stop_all()

func _show_classes():
	get_node("classes_animation").play("show")

func _hide_classes():
	get_node("classes_animation").play("hide")

func _start():
	_hide_welcome()
	_show_classes()

func _show_cards(target):
	var t = get_node("classes/control/list/"+target+"/Label")
	get_node("cardview_animation").play("show")
	get_node("cards_view/group_name").set_text(t.get_text())
	_load_card_data(target)

func _hide_cards():
	get_node("cardview_animation").play("hide")
	
func _show_menu():
	get_node("menu_animation").play("show")
	
func _hide_menu():
	get_node("menu_animation").play("hide")

func _hide_info():
	get_node("info_animation").play("hide")

func _show_info():
	get_node("info_animation").play("show")

func _show_inventory():
	get_node("inventory_animation").play("show")

func _show_panel(target):
	if(active_panel=="info"):
		_hide_info()
	get_node(target+"_animation").play("show")
	active_panel = target

func _hide_panel(target):
	get_node(target+"_animation").play("hide")

func _reset_active_panel():
	active_panel = "info"
	
func _select_class():
	_hide_cards()
	_hide_menu()
	_hide_panel(active_panel)
	_reset_active_panel()
	_show_classes()

func _home_from_cards():
	_hide_cards()
	_free_card_nodes()
	_hide_menu()
	_show_welcome("animate")
	_hide_panel(active_panel)
	_reset_active_panel()
	
func _show_main_ui(target):
	_hide_classes()
	_show_cards(target)
	_show_info()
	_show_menu()
	_reset_active_panel()
	
func _instance(id,name,fbid):
	var container = get_node("cards_view/container/control")
	var children = container.get_child_count()
	# remove last empty child
	var last_child = container.get_child(children-1)
	container.remove_child(last_child)
	var card_scene = load("res://scenes/card.scn")
	var card_node = card_scene.instance()
	card_node.get_node("card-control/name").set_text(name)
	card_node.get_node("card-control/id-num").set_text(id)
	var texture = load("res://assets/profiles/"+fbid+".png")
	card_node.get_node("card-control/profile-img").set_texture(texture)
	var control_node = Control.new()
	var empty_control = Control.new()
	control_node.add_child(card_node)
	container.add_child(control_node)
	container.add_child(empty_control)
	
func _ready():
	get_node("welcome/start").connect("pressed",self,"_start")
	get_node("cards_view/close").connect("pressed",self,"_select_class")
	get_node("menu/menu").connect("pressed",self,"_select_class")
	get_node("menu/home").connect("pressed",self,"_home_from_cards")
	get_node("menu/inventory").connect("pressed",self,"_show_panel",["inventory"])
	get_node("classes/control/list/a").connect("pressed",self,"_show_main_ui",["a"])
	get_node("classes/control/list/b").connect("pressed",self,"_show_main_ui",["b"])
	get_node("classes/control/list/c").connect("pressed",self,"_show_main_ui",["c"])
	get_node("classes/control/list/e").connect("pressed",self,"_show_main_ui",["e"])
	get_node("classes/control/list/demo").connect("pressed",self,"_show_main_ui",["demo"])

