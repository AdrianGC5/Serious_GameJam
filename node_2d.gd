extends Node2D

signal rum
signal milk
signal nada
var CurDri = ["rum","milk","nada"]
var rng := RandomNumberGenerator.new()
var choosenDrink
var numberrum : int
@export var holddrink = 0


func _ready() -> void:
	randomize()
	CurDri.shuffle()
	choosenDrink = CurDri[0]
	
	if choosenDrink == "rum":
		rum.emit()
		holddrink = "rum"
		print(holddrink)
	
	if choosenDrink == "milk":
		milk.emit()
		holddrink = "milk"
		print(holddrink)
	
	if choosenDrink == "nada":
		nada.emit()
		holddrink = "nada"
		print(holddrink)
