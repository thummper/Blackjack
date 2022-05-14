
extends Control
var upgradeDetails
var upgradeVars 
var quantity = 0
var cost = 0


onready var upgradeTitle = get_node("UpgradeLeft/VBoxContainer2/UpgradeTitle")
onready var upgradeDesc = get_node("UpgradeLeft/VBoxContainer2/VBoxContainer/UpgradeDescription")           
onready var purchaseButton = get_node("UpgradeRight/PurchaseButton")



# Called when the node enters the scene tree for the first time.
func _ready():
	upgradeTitle.text = upgradeDetails.name
	
	# Description needs to be formatted

	var formattedDescription = upgradeDetails.description % [upgradeVars[upgradeDetails.upgradeVar], (upgradeVars[upgradeDetails.upgradeVar] + upgradeDetails.changeAmount) ]
	upgradeDesc.text = formattedDescription
	updatePrice()

func setDetails(upgrade, _upgradeVars):
	upgradeDetails = upgrade
	# Does this update?
	upgradeVars = _upgradeVars
	

func updatePrice():
	cost = floor(upgradeDetails.startPrice *  pow(upgradeDetails.costBase, (quantity + 1) / upgradeDetails.countFactor ))
	purchaseButton.text = str(cost)
