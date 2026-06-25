extends Sprite2D

const RumSpt = preload("res://bloc.png")
const MilkSpt = preload("res://spr_ui_progress_strip5.png")

func _ready() -> void:
	pass
		
 




func _on_drinkger_rum() -> void:
	self.texture = RumSpt


func _on_drinkger_milk() -> void:
	self.texture = MilkSpt
