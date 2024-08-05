class_name BaseAddonPart
extends Resource

@export var name:String = ""
@export var sprite:Texture = null

@export var AdditionalHealth:int =0
@export var AdditionalAttack:int =0
@export var AdditionalDefence:int =0
@export var AdditionalSpeed:int =0
@export var AdditionalMana:int =0
@export var AdditionalSpecial:int =0

@export var Move:BaseMove
@export var type:GlobalsScript.MoveType

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
