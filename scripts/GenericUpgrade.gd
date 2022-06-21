
extends Control
signal buttonPressed
var upgradeDetails
var upgradeVars 
var upgradeName
var quantity = 0
var cost = 0



onready var upgradeDesc = get_node("UpgradeLeft/VBoxContainer2/VBoxContainer/UpgradeDescription")           
onready var purchaseButton = get_node("UpgradeRight/PurchaseButton")

onready var upgradeTitle = get_node("UpgradeLeft/VBoxContainer2/TitleInformation/Name")
onready var upgradeQuantitiy = get_node("UpgradeLeft/VBoxContainer2/TitleInformation/Quantity")



# Called when the node enters the scene tree for the first time.
func _ready():
	# Note labels are updated on ready because set details is called before the node enters (no onready vars)
	upgradeTitle.text = upgradeDetails.name
	upgradeQuantitiy.text = "(0)"
	updatePrice()
	purchaseButton.connect("pressed", self, "emitPressed")
	

func setDetails(upgrade, _upgradeVars):
	upgradeDetails = upgrade
	upgradeName = upgradeDetails.upgradeVar
	upgradeVars = _upgradeVars
	
	
	
	
	

func updatePrice():
	cost = floor(upgradeDetails.startPrice *  pow(upgradeDetails.costBase, (quantity + 1) / upgradeDetails.countFactor ))
	purchaseButton.text = str(cost)
	var formattedDescription = upgradeDetails.description % [upgradeVars[upgradeDetails.upgradeVar], (upgradeVars[upgradeDetails.upgradeVar] + upgradeDetails.changeAmount) ]
	upgradeDesc.text = formattedDescription
	
	upgradeQuantitiy.text = "(" + str(quantity) + ")"
	
	
	
func emitPressed():
	emit_signal("buttonPressed")
