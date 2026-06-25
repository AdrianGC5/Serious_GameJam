extends Sprite2D

const RumSpt = preload("res://bloc.png")
const MilkSpt = preload("res://Assets/temp assets/spin_wheel_button.png")

func _ready() -> void:
	pass
		
 


func _on_node_2d_milk() -> void:
	self.texture = MilkSpt


func _on_node_2d_rum() -> void:
	self.texture = RumSpt
