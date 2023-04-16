extends Node2D

onready var stock_1 := $Stock1/Stock
onready var stock_2 := $Stock2/Stock2
onready var stock_1_button := $Stock1/Stock/VBoxContainer/InvestButton
onready var stock_2_button := $Stock2/Stock2/VBoxContainer/InvestButton
onready var cash_label := $Background/CashLabel
onready var results_label := $Background/ResultsLabel

var current_cash := 10000


# Called when the node enters the scene tree for the first time.
func _ready():
	
	stock_1_button.connect("pressed", self, "_on_Stock1_chosen")
	stock_2_button.connect("pressed", self, "_on_Stock2_chosen")
	

func invest(stock: Node) -> void:
	
	randomize()
	
	var value := 0
	var percent = (randi() % 101) / 1.0
	
	if percent <= stock.profit_percent:
		
		value = stock.profit_value
		
	else:
		
		value = -stock.loss_value
		
	
	update_cash(value)
	
	

func update_cash(amount: int) -> void:
	
	current_cash += amount
	
	cash_label.text = "Current Cash: " + str(current_cash)
	
	if(current_cash >= 50000):
		
		results_label.text = "You Win!"
		stock_1_button.hide()
		stock_2_button.hide()
		
	elif(current_cash <= 0):
		
		results_label.text = "You Lose..."
		stock_1_button.hide()
		stock_2_button.hide()
		
	
	stock_1.create_stock()
	stock_2.create_stock()
	

func _on_Stock1_chosen() -> void:
	
	invest(stock_1)
	

func _on_Stock2_chosen() -> void:
	
	invest(stock_2)
	
