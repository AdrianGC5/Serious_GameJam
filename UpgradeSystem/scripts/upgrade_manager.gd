extends Control

@onready var upgrade_list = $UpgradeList
@onready var card1 = $HBoxContainer/Card1
@onready var card2 = $HBoxContainer/Card2
@onready var card3 = $HBoxContainer/Card3

var current_choices: Array[UpgradeData] = []
var chosen_upgrade: UpgradeData = null

func _ready():
	pick_random_upgrades()
	connect_buttons()

func pick_random_upgrades():
	current_choices.clear()
	var temp_list = upgrade_list.all_upgrades.duplicate()
	
	for i in range(3):
		var random_index = randi() % temp_list.size()
		current_choices.append(temp_list[random_index])
		temp_list.remove_at(random_index)

	display_upgrade_on_card(card1, current_choices[0])
	display_upgrade_on_card(card2, current_choices[1])
	display_upgrade_on_card(card3, current_choices[2])

func display_upgrade_on_card(card: VBoxContainer, upgrade: UpgradeData):
	card.get_node("NameLabel").text = upgrade.upgrade_name
	card.get_node("DescriptionLabel").text = upgrade.description
	card.get_node("ProLabel").text = "Pro: " + upgrade.pro
	card.get_node("ConLabel").text = "Con: " + upgrade.con

func connect_buttons():
	card1.get_node("PickButton").pressed.connect(func(): on_upgrade_picked(0))
	card2.get_node("PickButton").pressed.connect(func(): on_upgrade_picked(1))
	card3.get_node("PickButton").pressed.connect(func(): on_upgrade_picked(2))

func on_upgrade_picked(index: int):
	chosen_upgrade = current_choices[index]
	print("Player picked: " + chosen_upgrade.upgrade_name)
	card1.hide()
	card2.hide()
	card3.hide()
