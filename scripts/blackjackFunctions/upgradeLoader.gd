extends Node

var upgradeJSONPath = "res://jsondata/upgrades.json"
var upgradeJSON
var upgradeScene = preload("res://scenes/GenericUpgrade.tscn")
var upgradeStorage = []
var upgradeVars

func _init(_upgradeVars):
	print("Upgrade loader has initialised")
	upgradeJSON = load_json(upgradeJSONPath)
	# I really hope this is a reference 
	upgradeVars = _upgradeVars
	if upgradeJSON != null:
		generateUpgrades()
	else:
		print("Failed to open upgrade json file")
	

	


func load_json(path):
	var file = File.new()
	if file.open(path, file.READ) != OK: return
	return parse_json(file.get_as_text())
	
func generateUpgrades():
	var upgrades = upgradeJSON['upgrades']
	for upgrade in upgrades:
		# Instance the upgrade scene and add all the information
		print("Should make upgrade with title: ", upgrade.name)
		var newUpgrade = upgradeScene.instance()
		# Either pass upgrade vars here, or update all upgrades on a certain signal emit (upgrade purchased)
		newUpgrade.setDetails(upgrade, upgradeVars)
		
		upgradeStorage.push_back(newUpgrade)

func displayUpgrades(container):
	for upgradeInstance in upgradeStorage:
		container.add_child(upgradeInstance)

