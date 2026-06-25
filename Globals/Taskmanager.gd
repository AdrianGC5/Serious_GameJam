extends Node

signal start
signal spin
signal death
signal end
signal pirate
signal table
signal enemy_spin
signal spin_finished
signal health_changed
signal spin_results_ready
signal duel_won
signal duel_lost

const MAX_HEALTH := 10

var game_has_booted: bool
var game_has_started: bool

var wheel_result: String
var player_turn: bool
var is_interacting: bool

var player_health: int = MAX_HEALTH
var enemy_health: int = MAX_HEALTH

var player_drink_value: int = 0
var enemy_drink_value: int = 0

var owned_upgrades: Array[String] = []

var dead_mans_spin_used: bool = false
var spill_grog_used: bool = false
var davys_gamble_used: bool = false
var second_wind_used: bool = false

var spill_grog_active: bool = false
var davys_gamble_active: bool = false

var _spin_resolution_chosen: bool = false
var _spin_resolution_action: String = ""


func has_upgrade(upgrade_name: String) -> bool:
	return upgrade_name in owned_upgrades


func start_duel() -> void:
	reset_duel_state()


func reset_duel_state() -> void:
	player_health = MAX_HEALTH
	enemy_health = MAX_HEALTH
	player_drink_value = 0
	enemy_drink_value = 0
	player_turn = true

	dead_mans_spin_used = false
	spill_grog_used = false
	davys_gamble_used = false
	second_wind_used = false
	spill_grog_active = false
	davys_gamble_active = false

	health_changed.emit()


func reset_between_duels() -> void:
	reset_duel_state()
	end.emit()


func activate_davys_gamble() -> bool:
	if not DuelUpgradeEffects.can_use_davys_gamble(self):
		return false
	davys_gamble_used = true
	davys_gamble_active = true
	return true


func activate_spill_the_grog() -> bool:
	if not DuelUpgradeEffects.can_use_spill_the_grog(self):
		return false
	spill_grog_used = true
	spill_grog_active = true
	return true


func activate_dead_mans_spin() -> bool:
	if not DuelUpgradeEffects.can_use_dead_mans_spin(self):
		return false
	dead_mans_spin_used = true
	_spin_resolution_action = "respin"
	_spin_resolution_chosen = true
	return true


func confirm_spin_results() -> void:
	_spin_resolution_action = "apply"
	_spin_resolution_chosen = true


func resolve_spin_results() -> String:
	spill_grog_active = false
	davys_gamble_active = false
	_spin_resolution_chosen = false
	_spin_resolution_action = ""

	spin_results_ready.emit()

	while not _spin_resolution_chosen:
		await get_tree().process_frame

	var action := _spin_resolution_action
	_spin_resolution_action = ""
	_spin_resolution_chosen = false
	return action


func apply_spin_damage() -> void:
	var enemy_damage := DuelUpgradeEffects.get_enemy_damage(self)
	var player_damage := DuelUpgradeEffects.get_player_damage(self)

	enemy_health = maxi(enemy_health - enemy_damage, 0)
	player_health = maxi(player_health - player_damage, 0)

	DuelUpgradeEffects.try_trigger_second_wind(self)
	health_changed.emit()
	_check_death()


func _check_death() -> void:
	if enemy_health <= 0:
		death.emit()
		duel_won.emit()
	elif player_health <= 0:
		death.emit()
		duel_lost.emit()
