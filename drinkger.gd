extends Node2D

signal rum
signal milk
signal nada
var CurDri = ["rum","milk","nada"]
var rng := RandomNumberGenerator.new()
var choosenDrink
var numberrum : int
var printeda


func _ready() -> void:
	randomize()
	CurDri.shuffle()
	choosenDrink = CurDri[0]
	
	if choosenDrink == "rum":
		rum.emit()
		printeda = "rum"
		print(printeda)
	
	if choosenDrink == "milk":
		milk.emit()
		printeda = "milk"
		print(printeda)
	
	if choosenDrink == "nada":
		nada.emit()
		printeda = "nada"
		print(printeda)
