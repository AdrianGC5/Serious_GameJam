extends Control
@export var is_spin: bool = false
@export var speed: int = 6
@export var power: int = 6
@onready var btn_spin: TextureButton = $background/btn_spin
signal sig_reward
const ARROW_OFFSET_TOP := -22.5
const ARROW_OFFSET_BOTTOM := -180.0
var reward_position: float = 0.0
var vat_pham = [
	{
		"name": "Drink 1",
		"from": 0,
		"to": 45,
		"value": 1,
		"ma_vat_pham": 200,
		"ten_vat_pham": "Small Grog"
	},
	{
		"name": "Drink 2",
		"from": 45,
		"to": 90,
		"value": 1,
		"ma_vat_pham": 201,
		"ten_vat_pham": "Rum Shot"
	},
	{
		"name": "Drink 3",
		"from": 90,
		"to": 135,
		"value": 2,
		"ma_vat_pham": 202,
		"ten_vat_pham": "Dark Rum"
	},
	{
		"name": "Drink 4",
		"from": 135,
		"to": 180,
		"value": 2,
		"ma_vat_pham": 203,
		"ten_vat_pham": "Spiced Rum"
	},
	{
		"name": "Drink 5",
		"from": 180,
		"to": 225,
		"value": 3,
		"ma_vat_pham": 204,
		"ten_vat_pham": "Grog Mug"
	},
	{
		"name": "Drink 6",
		"from": 225,
		"to": 270,
		"value": 3,
		"ma_vat_pham": 205,
		"ten_vat_pham": "Kraken's Brew"
	},
	{
		"name": "Drink 7",
		"from": 270,
		"to": 315,
		"value": 4,
		"ma_vat_pham": 206,
		"ten_vat_pham": "Double Grog"
	},
	{
		"name": "Drink 8",
		"from": 315,
		"to": 360,
		"value": 5,
		"ma_vat_pham": 207,
		"ten_vat_pham": "Blackbeard's Bottle"
	},
]

func _ready() -> void:
	if not btn_spin.pressed.is_connected(_on_btn_spin_pressed):
		btn_spin.pressed.connect(_on_btn_spin_pressed)
	Taskmanager.enemy_spin.connect(_on_btn_spin_pressed)
	Taskmanager.end.connect(_on_duel_reset)
	

func _on_duel_reset() -> void:
	is_spin = false
	btn_spin.disabled = false

func _find_segment(position: float, arrow_offset: float) -> Dictionary:
	for item in vat_pham:
		var segment_from := float(item.from) + arrow_offset
		var segment_to := float(item.to) + arrow_offset
		if position >= segment_from and position <= segment_to:
			return item
	return vat_pham[0]

func _store_spin_results() -> void:
	var top_segment := _find_segment(reward_position, ARROW_OFFSET_TOP)
	var bottom_segment := _find_segment(reward_position, ARROW_OFFSET_BOTTOM)
	Taskmanager.enemy_drink_value = top_segment.value
	Taskmanager.player_drink_value = bottom_segment.value
	Taskmanager.wheel_result = "%s vs %s" % [top_segment.ten_vat_pham, bottom_segment.ten_vat_pham]
	print("Enemy drinks: ", top_segment.ten_vat_pham, " (", top_segment.value, ")")
	print("Player drinks: ", bottom_segment.ten_vat_pham, " (", bottom_segment.value, ")")
	sig_reward.emit(top_segment.ma_vat_pham)

func request_spin() -> void:
	_on_btn_spin_pressed()

func _on_btn_spin_pressed() -> void:
	if is_spin:
		return
	is_spin = true
	Taskmanager.spin.emit()
	reward_position = float(randi_range(0, 360))
	_store_spin_results()
	var tween := get_tree().create_tween()
	tween.tween_property(
		%front,
		"rotation_degrees",
		reward_position + 360.0 * speed * power,
		3.0
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	tween.connect("finished", func() -> void:
		var old_rotation_degrees: float = %front.rotation_degrees
		is_spin = false
		Taskmanager.spin_finished.emit()
		if Taskmanager.player_turn:
			Taskmanager.player_turn = false
			btn_spin.disabled = true
		else:
			Taskmanager.player_turn = true
			btn_spin.disabled = false
		if old_rotation_degrees > 360.0:
			%front.rotation_degrees = fmod(old_rotation_degrees, 360.0)
	)
