extends Node

var all_upgrades: Array[UpgradeData] = []

func _ready():
	var upgrade1 = UpgradeData.new()
	upgrade1.upgrade_name = "Iron Stomach"
	upgrade1.description = "Your gut is made of iron. Drinks don't hit as hard."
	upgrade1.pro = "Drinks cost less health"
	upgrade1.con = "Cannot use Second Wind"
	all_upgrades.append(upgrade1)

	var upgrade2 = UpgradeData.new()
	upgrade2.upgrade_name = "Second Wind"
	upgrade2.description = "Just when you're about to pass out, you find a second wind."
	upgrade2.pro = "Recover health when critical"
	upgrade2.con = "Drinks cost more health after recovery"
	all_upgrades.append(upgrade2)

	var upgrade3 = UpgradeData.new()
	upgrade3.upgrade_name = "Dead Man's Spin"
	upgrade3.description = "Not happy with your spin? Take your chances again."
	upgrade3.pro = "Re-spin the wheel once per duel"
	upgrade3.con = ""
	all_upgrades.append(upgrade3)

	var upgrade4 = UpgradeData.new()
	upgrade4.upgrade_name = "Davy's Gamble"
	upgrade4.description = "Feeling bold? Double the drinks for everyone."
	upgrade4.pro = "Double drinks for both players after seeing your spin"
	upgrade4.con = ""
	all_upgrades.append(upgrade4)

	var upgrade5 = UpgradeData.new()
	upgrade5.upgrade_name = "Spill the Grog"
	upgrade5.description = "Oops, clumsy hands. Only works on the big pours."
	upgrade5.pro = "Take half drinks once per duel"
	upgrade5.con = "Only works when you land on 3 or more drinks"
	all_upgrades.append(upgrade5)
