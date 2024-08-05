class_name BaseCorePart
extends Resource


@export var name:String = "MissingNoCore"
@export var sprite:Texture = null

@export var BaseHealth:int =0
@export var BaseAttack:int =0
@export var BaseDefence:int =0
@export var BaseSpeed:int =0
@export var BaseMana:int =0
@export var BaseSpecial:int =0


@export var LegsAvailable:bool = true
@export var ArmsAvailable:bool = true
@export var AdornementAvailable:bool = true

@export var Move:BaseMove

@export var type:GlobalsScript.MoveType

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func getAvailableAddons():
	var availableAddonsEnums = []
	
	if(LegsAvailable):
		availableAddonsEnums.append(Globals.BodyPartsTypes.LEGS)
	if(ArmsAvailable):
		availableAddonsEnums.append(Globals.BodyPartsTypes.ARMS)
	if(AdornementAvailable):
		availableAddonsEnums.append(Globals.BodyPartsTypes.ADORNMENT)
	return availableAddonsEnums

#returns the total stats including addon bonuses

