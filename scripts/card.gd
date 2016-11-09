
extends Control


func glow():
	get_node("card-control/glow").show()

func dim():
	get_node("card-control/glow").hide()

func _ready():
	get_node("card-control/glow").hide()
	get_node("card-control").connect("mouse_enter",self,"glow")
	get_node("card-control").connect("mouse_exit",self,"dim")
	get_node("card-control/progress-health").connect("mouse_enter",self,"glow")
	get_node("card-control/progress-health").connect("mouse_exit",self,"dim")
	get_node("card-control/progress-tardiness").connect("mouse_enter",self,"glow")
	get_node("card-control/progress-tardiness").connect("mouse_exit",self,"dim")


