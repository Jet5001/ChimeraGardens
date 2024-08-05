class_name Heal
extends BaseMove

func setValues():
	name = "Heal"
	type = Globals.MoveType.NATURE
	baseDamage = 0
	accuracy = 1
func seccondaryEffect(_target:BaseCreature, _source:BaseCreature):
	_source.currentHealth = min(_source.maxHealth, _source.currentHealth + (_source.maxHealth*0.25))
	pass



