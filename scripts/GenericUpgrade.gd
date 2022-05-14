
extends Control
signal buttonPressed
var upgradeDetails
var upgradeVars 
var upgradeName
var quantity = 0
var cost = 0


onready var upgradeTitle = get_node("UpgradeLeft/VBoxContainer2/UpgradeTitle")
onready var upgradeDesc = get_node("UpgradeLeft/VBoxContainer2/VBoxContainer/UpgradeDescription")           
onready var purchaseButton = get_node("UpgradeRight/PurchaseButton")



# Called when the node enters the scene tree for the first time.
func _ready():
	upgradeTitle.text = upgradeDetails.name
	# Description needs to be formatted

	updatePrice()
	
	purchaseButton.connect("pressed", self, "emitPressed")

func setDetails(upgrade, _upgradeVars):
	upgradeDetails = upgrade
	# Does this update?
	upgradeName = upgradeDetails.upgradeVar
	upgradeVars = _upgradeVars
	

func updatePrice():
	cost = floor(upgradeDetails.startPrice *  pow(upgradeDetails.costBase, (quantity + 1) / upgradeDetails.countFactor ))
	purchaseButton.text = str(cost)
	var formattedDescription = upgradeDetails.description % [upgradeVars[upgradeDetails.upgradeVar], (upgradeVars[upgradeDetails.upgradeVar] + upgradeDetails.changeAmount) ]
	upgradeDesc.text = formattedDescription
	
	
func emitPressed():
	emit_signal("buttonPressed")
