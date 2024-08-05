class_name BaseCreature
extends Resource

@export var currentCore:BaseCorePart
@export var armsAddon:BaseAddonPart
@export var legsAddon:BaseAddonPart
@export var adornmentAddon:BaseAddonPart
@export var name:String = "Enemy"
@export var sprite:Texture = null


var maxHealth:int
@export var currentHealth:int
var attack:int
var defence:int
var speed:int
var maxMana:int
@export var currentMana:int
var special:int



func setupStats():	
	maxHealth = currentCore.BaseHealth
	attack = currentCore.BaseAttack
	defence = currentCore.BaseDefence
	speed = currentCore.BaseSpeed
	maxMana = currentCore.BaseMana
	special = currentCore.BaseSpecial
	for i in getCurrentAddons():
		maxHealth += i.AdditionalHealth
		attack += i.AdditionalAttack
		defence += i.AdditionalDefence
		special += i.AdditionalSpeed
		maxMana += i.AdditionalMana
		special += i.AdditionalSpecial
	
	print("%s stats" %name)
	print("health: %f" %maxHealth)
	print("ATk: %f" %attack)
	print("def: %f" %defence)
	print("special: %f" %special)
	print("")
	print("")
	
func getCurrentAddons() -> Array[BaseAddonPart]:
	var currentAddons:Array[BaseAddonPart] = []
	for i in [armsAddon,legsAddon,adornmentAddon]:
		if (i != null):
			currentAddons.append(i)
	return currentAddons

func getMoves() -> Array[BaseMove]:
	var currentMoves:Array[BaseMove] = []
	currentMoves.append(currentCore.Move)
	for i in [armsAddon,legsAddon,adornmentAddon]:
		if (i != null):
			currentMoves.append(i.Move)
	return currentMoves

func setupMoves():
	currentCore.Move.setValues()
	for part in getCurrentAddons():
		part.Move.setValues()
