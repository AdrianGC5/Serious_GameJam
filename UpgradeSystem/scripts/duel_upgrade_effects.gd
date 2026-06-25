class_name DuelUpgradeEffects
extends RefCounted

const IRON_STOMACH := "Iron Stomach"
const SECOND_WIND := "Second Wind"
const DEAD_MANS_SPIN := "Dead Man's Spin"
const DAVYS_GAMBLE := "Davy's Gamble"
const SPILL_THE_GROG := "Spill the Grog"

const SECOND_WIND_THRESHOLD := 3
const SECOND_WIND_HEAL := 3


static func has_upgrade(taskmanager: Node, upgrade_name: String) -> bool:
	return upgrade_name in taskmanager.owned_upgrades


static func get_enemy_damage(taskmanager: Node) -> int:
	var damage: int = taskmanager.enemy_drink_value
	if taskmanager.davys_gamble_active:
		damage *= 2
	return maxi(damage, 0)


static func get_player_damage(taskmanager: Node) -> int:
	var damage: int = taskmanager.player_drink_value

	if taskmanager.davys_gamble_active:
		damage *= 2

	if taskmanager.spill_grog_active and damage >= 3:
		damage = damage / 2

	if has_upgrade(taskmanager, IRON_STOMACH):
		damage -= 1

	return maxi(damage, 0)


static func can_use_spill_the_grog(taskmanager: Node) -> bool:
	return (
		has_upgrade(taskmanager, SPILL_THE_GROG)
		and not taskmanager.spill_grog_used
		and taskmanager.player_drink_value >= 3
	)


static func can_use_davys_gamble(taskmanager: Node) -> bool:
	return has_upgrade(taskmanager, DAVYS_GAMBLE) and not taskmanager.davys_gamble_used


static func can_use_dead_mans_spin(taskmanager: Node) -> bool:
	return has_upgrade(taskmanager, DEAD_MANS_SPIN) and not taskmanager.dead_mans_spin_used


static func try_trigger_second_wind(taskmanager: Node) -> void:
	if taskmanager.second_wind_used:
		return
	if not has_upgrade(taskmanager, SECOND_WIND):
		return
	if taskmanager.player_health > SECOND_WIND_THRESHOLD:
		return

	taskmanager.second_wind_used = true
	taskmanager.player_health = mini(
		taskmanager.player_health + SECOND_WIND_HEAL,
		taskmanager.MAX_HEALTH
	)
