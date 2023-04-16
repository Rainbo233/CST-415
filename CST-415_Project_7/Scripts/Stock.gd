extends Control

onready var name_label := $VBoxContainer/StockNameLabel
onready var profit_label := $VBoxContainer/HBoxContainer/ProfitLabel
onready var loss_label := $VBoxContainer/HBoxContainer/LossLabel
onready var button := $InvestButton

var name_list := [
	
	"Big Boys Inc", 
	"D Corp", 
	"Riverside City Transit", 
	"GCU Robotics", 
	"Space X 2", 
	"Rattlesnake Sporting Goods",
	"Bad Dragon",
	"Valhalla Airlines",
	"Alduin Inc.",
	"Galvaknuckles Unlimited",
	"Hi Mom!",
	"Super Drinks",
	"Totally not a Money Laundering Scheme",
	"Chippo Man"
	
]
var profit_value := 0
var profit_percent := 0.0
var loss_value := 0
var loss_percent := 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	
	create_stock()
	

func create_stock() -> void:
	
	randomize()
	
	name_label.text = name_list[randi() % name_list.size()]
	profit_value = randi() % 10001
	profit_percent = (randi() % 101) / 1.0
	loss_value = randi() % 10001
	loss_percent = 100.0 - profit_percent
	
	profit_label.text = "Potential Profit: $" + str(profit_value) + " (" + str(profit_percent) + "%)"
	loss_label.text = "Potential Loss: $" + str(loss_value) + " (" + str(loss_percent) + "%)"
	
