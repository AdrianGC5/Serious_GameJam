extends Control
signal upgrade_picked(upgrade: UpgradeData)
@onready var upgrade_list: Node = $"upgradeList(Node)"
@onready var card1: PanelContainer = $HBoxContainer/Card1
@onready var card2: PanelContainer = $HBoxContainer/Card2
@onready var card3: PanelContainer = $HBoxContainer/Card3
@onready var title_label: Label = $"ChooseAnUpgrade(Label)"
var current_choices: Array[UpgradeData] = []
var chosen_upgrade: UpgradeData = null

func _ready() -> void:
	hide()
	connect_buttons()

func show_upgrade_selection() -> bool:
	pick_random_upgrades()
	if current_choices.is_empty():
		_clear_cards()
		hide()
		return false
	show()
	return true

func pick_random_upgrades() -> void:
	current_choices.clear()
	var available: Array[UpgradeData] = []
	for upgrade in upgrade_list.all_upgrades:
		if upgrade.upgrade_name in Taskmanager.owned_upgrades:
			continue
		if _is_upgrade_blocked(upgrade.upgrade_name):
			continue
		available.append(upgrade)
	if available.is_empty():
		return
	available.shuffle()
	var choice_count := mini(3, available.size())
	for i in range(choice_count):
		current_choices.append(available[i])
	display_upgrade_on_card(card1, current_choices[0] if current_choices.size() > 0 else null)
	display_upgrade_on_card(card2, current_choices[1] if current_choices.size() > 1 else null)
	display_upgrade_on_card(card3, current_choices[2] if current_choices.size() > 2 else null)
	card1.visible = current_choices.size() > 0
	card2.visible = current_choices.size() > 1
	card3.visible = current_choices.size() > 2

func _clear_cards() -> void:
	display_upgrade_on_card(card1, null)
	display_upgrade_on_card(card2, null)
	display_upgrade_on_card(card3, null)
	card1.visible = false
	card2.visible = false
	card3.visible = false

func display_upgrade_on_card(card: PanelContainer, upgrade: UpgradeData) -> void:
	var pick_button: Button = card.get_node("VBoxContainer/PickButton")
	if upgrade == null:
		card.hide()
		pick_button.disabled = true
		return
	card.show()
	pick_button.disabled = false
	card.get_node("VBoxContainer/Name").text = upgrade.upgrade_name
	card.get_node("VBoxContainer/Description").text = upgrade.description
	card.get_node("VBoxContainer/Pro").text = "Pro: " + upgrade.pro
	var con_text := upgrade.con
	card.get_node("VBoxContainer/Con").text = "Con: " + con_text if con_text != "" else ""

func connect_buttons() -> void:
	card1.get_node("VBoxContainer/PickButton").pressed.connect(func(): on_upgrade_picked(0))
	card2.get_node("VBoxContainer/PickButton").pressed.connect(func(): on_upgrade_picked(1))
	card3.get_node("VBoxContainer/PickButton").pressed.connect(func(): on_upgrade_picked(2))

func _is_upgrade_blocked(upgrade_name: String) -> bool:
	if upgrade_name == DuelUpgradeEffects.SECOND_WIND:
		return Taskmanager.has_upgrade(DuelUpgradeEffects.IRON_STOMACH)
	if upgrade_name == DuelUpgradeEffects.IRON_STOMACH:
		return Taskmanager.has_upgrade(DuelUpgradeEffects.SECOND_WIND)
	return false

func on_upgrade_picked(index: int) -> void:
	if index >= current_choices.size():
		return
	chosen_upgrade = current_choices[index]
	if chosen_upgrade.upgrade_name not in Taskmanager.owned_upgrades:
		Taskmanager.owned_upgrades.append(chosen_upgrade.upgrade_name)
	hide()
	upgrade_picked.emit(chosen_upgrade)
