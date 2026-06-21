extends Node

var all_upgrades: Array[UpgradeData] = []

func _ready():
	var upgrade1 = UpgradeData.new()
	upgrade1.name = "Light Pour"
	upgrade1.description = "Add a segment where you drink less"
	upgrade1.pro = "Less drinks for you"
	upgrade1.con = "Opponent also drinks less"
	all_upgrades.append(upgrade1)

	var upgrade2 = UpgradeData.new()
	upgrade2.name = "Heavy Pour"
	upgrade2.description = "Add a segment where opponent drinks more"
	upgrade2.pro = "Opponent drinks a lot"
	upgrade2.con = "You also drink more"
	all_upgrades.append(upgrade2)

	var upgrade3 = UpgradeData.new()
	upgrade3.name = "Dead Calm"
	upgrade3.description = "Make one segment blank"
	upgrade3.pro = "Safe round when it lands"
	upgrade3.con = "Protects opponent too"
	all_upgrades.append(upgrade3)

	var upgrade4 = UpgradeData.new()
	upgrade4.name = "Kraken Trap"
	upgrade4.description = "Add a trap segment to the wheel"
	upgrade4.pro = "Opponent drinks double if it lands"
	upgrade4.con = "Completely random if it triggers"
	all_upgrades.append(upgrade4)
