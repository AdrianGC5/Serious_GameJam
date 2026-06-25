extends Control

@onready var canvas_layer: CanvasLayer = get_parent()
@onready var player_health_bar: ProgressBar = $MarginContainer/VBoxContainer/PlayerRow/PlayerHealthBar
@onready var enemy_health_bar: ProgressBar = $MarginContainer/VBoxContainer/EnemyRow/EnemyHealthBar
@onready var player_health_label: Label = $MarginContainer/VBoxContainer/PlayerRow/PlayerHealthLabel
@onready var enemy_health_label: Label = $MarginContainer/VBoxContainer/EnemyRow/EnemyHealthLabel
@onready var drink_result_label: Label = $MarginContainer/VBoxContainer/DrinkResultLabel
@onready var upgrade_buttons: HBoxContainer = $MarginContainer/VBoxContainer/UpgradeButtons
@onready var dead_mans_spin_button: Button = $MarginContainer/VBoxContainer/UpgradeButtons/DeadMansSpinButton
@onready var spill_grog_button: Button = $MarginContainer/VBoxContainer/UpgradeButtons/SpillGrogButton
@onready var davys_gamble_button: Button = $MarginContainer/VBoxContainer/UpgradeButtons/DavysGambleButton
@onready var confirm_button: Button = $MarginContainer/VBoxContainer/ConfirmButton


func _ready() -> void:
	Taskmanager.health_changed.connect(_update_health_bars)
	Taskmanager.spin.connect(_on_spin_started)
	Taskmanager.spin_results_ready.connect(_on_spin_results_ready)
	Taskmanager.end.connect(_reset_upgrade_button_labels)

	dead_mans_spin_button.pressed.connect(_on_dead_mans_spin_pressed)
	spill_grog_button.pressed.connect(_on_spill_grog_pressed)
	davys_gamble_button.pressed.connect(_on_davys_gamble_pressed)
	confirm_button.pressed.connect(_on_confirm_pressed)

	_update_health_bars()
	_set_spin_resolution_ui_visible(false)
	_set_duel_ui_enabled(false)


func _set_duel_ui_enabled(enabled: bool) -> void:
	canvas_layer.visible = enabled


func _on_spin_started() -> void:
	_set_duel_ui_enabled(false)
	_set_spin_resolution_ui_visible(false)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			# TEMP: fake a spin result for testing
			Taskmanager.player_drink_value = 3
			Taskmanager.enemy_drink_value = 2
			Taskmanager.spin_results_ready.emit()


func _update_health_bars() -> void:
	player_health_bar.max_value = Taskmanager.MAX_HEALTH
	enemy_health_bar.max_value = Taskmanager.MAX_HEALTH
	player_health_bar.value = Taskmanager.player_health
	enemy_health_bar.value = Taskmanager.enemy_health
	player_health_label.text = "%d / %d" % [Taskmanager.player_health, Taskmanager.MAX_HEALTH]
	enemy_health_label.text = "%d / %d" % [Taskmanager.enemy_health, Taskmanager.MAX_HEALTH]


func _on_spin_results_ready() -> void:
	_update_health_bars()
	_set_duel_ui_enabled(true)
	drink_result_label.text = "Enemy: %d drinks | You: %d drinks" % [
		Taskmanager.enemy_drink_value,
		Taskmanager.player_drink_value,
	]
	_set_spin_resolution_ui_visible(true)
	_refresh_upgrade_buttons()


func _set_spin_resolution_ui_visible(visible_state: bool) -> void:
	drink_result_label.visible = visible_state
	upgrade_buttons.visible = visible_state
	confirm_button.visible = visible_state
	if not visible_state:
		drink_result_label.text = ""


func _refresh_upgrade_buttons() -> void:
	_configure_upgrade_button(
		dead_mans_spin_button,
		"Dead Man's Spin",
		DuelUpgradeEffects.can_use_dead_mans_spin(Taskmanager),
		Taskmanager.dead_mans_spin_used
	)
	_configure_upgrade_button(
		spill_grog_button,
		"Spill the Grog",
		DuelUpgradeEffects.can_use_spill_the_grog(Taskmanager),
		Taskmanager.spill_grog_used
	)
	_configure_upgrade_button(
		davys_gamble_button,
		"Davy's Gamble",
		DuelUpgradeEffects.can_use_davys_gamble(Taskmanager),
		Taskmanager.davys_gamble_used
	)


func _configure_upgrade_button(button: Button, label: String, can_use: bool, used: bool) -> void:
	var owned := Taskmanager.has_upgrade(label)
	button.visible = owned and (can_use or used)
	button.disabled = used or not can_use
	button.text = label + (" (Used)" if used else "")


func _update_drink_preview() -> void:
	drink_result_label.text = "Enemy: %d drinks | You: %d drinks" % [
		DuelUpgradeEffects.get_enemy_damage(Taskmanager),
		DuelUpgradeEffects.get_player_damage(Taskmanager),
	]


func _on_dead_mans_spin_pressed() -> void:
	if Taskmanager.activate_dead_mans_spin():
		dead_mans_spin_button.disabled = true
		dead_mans_spin_button.text = "Dead Man's Spin (Used)"
		_set_spin_resolution_ui_visible(false)
		_set_duel_ui_enabled(false)


func _on_spill_grog_pressed() -> void:
	if Taskmanager.activate_spill_the_grog():
		spill_grog_button.disabled = true
		spill_grog_button.text = "Spill the Grog (Used)"
		_update_drink_preview()


func _on_davys_gamble_pressed() -> void:
	if Taskmanager.activate_davys_gamble():
		davys_gamble_button.disabled = true
		davys_gamble_button.text = "Davy's Gamble (Used)"
		_update_drink_preview()


func _on_confirm_pressed() -> void:
	_set_spin_resolution_ui_visible(false)
	_set_duel_ui_enabled(false)
	Taskmanager.confirm_spin_results()


func _reset_upgrade_button_labels() -> void:
	dead_mans_spin_button.text = "Dead Man's Spin"
	spill_grog_button.text = "Spill the Grog"
	davys_gamble_button.text = "Davy's Gamble"
	dead_mans_spin_button.disabled = false
	spill_grog_button.disabled = false
	davys_gamble_button.disabled = false
	_set_spin_resolution_ui_visible(false)
	_set_duel_ui_enabled(false)
