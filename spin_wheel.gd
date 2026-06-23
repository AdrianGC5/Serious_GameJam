extends Control

signal enemy_reward
signal player_reward


func _ready() -> void:
	%Dm.max_value = maxdrunknes
	set_health_bar()

@export var maxdrunknes = 10
@onready var currentdrunkes: int = 0
@export var is_spin: bool = false
@export var speed: int = 10
@export var power: int = 2
@export var reward_position = 0
var holddrink = 0

func set_health_bar() -> void:
	%Dm.value = currentdrunkes

func _on_h_scroll_bar_value_changed(value: float) -> void:
	power = int(value)
	print(power)



@export var rum: PackedScene

signal sig_reward
var vat_pham = [
	{
		"name": "Drink 1",
		"from": 0,
		"to": 45,
		"ma_vat_pham": 200,
		"ten_vat_pham": "Thanh Long"
	},
	{
		"name": "Drink 2",
		"from": 45,
		"to": 90,
		"ma_vat_pham": 0,
		"ten_vat_pham": "Gạch"
	},
	{
		"name": "Drink 3",
		"from": 90,
		"to": 135,
		"ma_vat_pham": 204,
		"ten_vat_pham": "Chanh"
	},
	{
		"name": "Drink 4",
		"from": 135,
		"to": 180,
		"ma_vat_pham": 203,
		"ten_vat_pham": "Dưa Hấu"
	},
	{
		"name": "Drink 5",
		"from": 180,
		"to": 225,
		"ma_vat_pham": 201,
		"ten_vat_pham": "Sầu Riêng"
	},
	{
		"name": "Drink 6",
		"from": 225,
		"to": 270,
		"ma_vat_pham": 0,
		"ten_vat_pham": "Gạch"
	},
	{
		"name": "Drink 7",
		"from": 270,
		"to": 315,
		"ma_vat_pham": 202,
		"ten_vat_pham": "Vãi"
	},
	{
		"name": "Drink 8",
		"from": 315,
		"to": 360,
		"ma_vat_pham": 0,
		"ten_vat_pham": "Gạch"
	}
	]

func _on_btn_spin_pressed():
	if is_spin == false:
		is_spin = true
		var tween = get_tree().create_tween().set_parallel(true)
		tween.connect("finished", func():
			#after tween finish animation, this function is call
			var old_rotation_degrees = %front.rotation_degrees
			#set is_spin = false to tell for user can press again
			is_spin = false
			if old_rotation_degrees > 360:
				#This part is to fix the error that when rotating the steamer once, it will not rotate counterclockwise
				var rad_ = fmod(old_rotation_degrees, 360)
				%front.rotation_degrees = rad_
			)
		reward_position = randi_range(0, 360) + power*5
		reward_position = fmod(reward_position, 360) #random position from 0 to 360 degrees
		var opposite_angle = fmod(reward_position + 180, 360)
		tween.tween_property(%front, "rotation_degrees", rotation_degrees +  360 * speed * reward_position , 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
		

		for item in vat_pham:
			if reward_position >= item.from - 22.5 and reward_position <= item.to - 22.5:
				print(item.name)
				#signal for another scene
				enemy_reward.emit()
				sig_reward.emit(item.ma_vat_pham)
				break
	

		for item in vat_pham:
			if opposite_angle >= item.from - 22.5 and opposite_angle <= item.to - 22.5:
				print(item.name)
				#signal for another scene
				player_reward.emit()
				sig_reward.emit(item.ma_vat_pham)
				break
	
	




var Bdrink = func _on_drinkger_rum() -> void:
	currentdrunkes = currentdrunkes + 1
	print(currentdrunkes)
	set_health_bar()


var non = func _on_drinkger_nada() -> void:
	print(currentdrunkes)
	set_health_bar()


var milk = func _on_drinkger_milk() -> void:
	currentdrunkes = currentdrunkes - 1
	if currentdrunkes < 0:
		currentdrunkes = 0
	print(currentdrunkes)
	set_health_bar()
