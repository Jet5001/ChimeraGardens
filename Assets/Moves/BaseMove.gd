class_name BaseMove
extends Resource
#enum MoveType {ABYSS,CELESTIAL,NATURE,MAGIC,PHYSICAL,CLOCKWORK}
@export var name:String = ""
@export var type:Globals.MoveType = Globals.MoveType.PHYSICAL
@export var baseDamage:int = 0
@export var accuracy:float = 0
@export var isSpecial:bool= false
func seccondaryEffect(target, source):#
	push_warning("SecondaryNotImplemented")

func setValues():
	push_error("FakeMove")
