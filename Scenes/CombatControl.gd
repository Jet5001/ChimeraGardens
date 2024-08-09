extends Control

@export var enemy:BaseCreature = null
@export var playerCreature:BaseCreature = null
var allowButtons:bool = true
var baseTextboxCooldown:float = 0.5
var textboxCooldown:float = 0
const GENERAL_DAMAGE_INCREASE = 1
signal textbox_closed
signal input_recieved
# Called when the node enters the scene tree for the first time.
func _ready():
	enemy.setupStats()
	enemy.currentHealth = enemy.maxHealth
	enemy.currentMana = enemy.maxMana
	enemy.setupMoves()
	playerCreature.setupStats()
	playerCreature.currentHealth = playerCreature.maxHealth
	playerCreature.currentMana = playerCreature.maxMana
	playerCreature.setupMoves()
	setupMoveMenu()
	$AnimationPlayer.stop()
	$FriendlyCollection/FriendlyHeathBar.max_value = playerCreature.maxHealth
	setHealth($FriendlyCollection/FriendlyHeathBar, playerCreature.currentHealth, playerCreature.maxHealth)

	#Setup Friendly Sprite
	$FriendlyCollection/SpritesContainer/FriendlyCore.texture = playerCreature.currentCore.sprite
	if (playerCreature.armsAddon != null):
		$FriendlyCollection/SpritesContainer/FriendlyArms.texture = playerCreature.armsAddon.sprite
	else:
		$FriendlyCollection/SpritesContainer/FriendlyArms.texture = null
	if (playerCreature.legsAddon != null):
		$FriendlyCollection/SpritesContainer/FriendlyLegs.texture = playerCreature.legsAddon.sprite
	else:
		$FriendlyCollection/SpritesContainer/FriendlyLegs.texture = null
	if (playerCreature.adornmentAddon != null):
		$FriendlyCollection/SpritesContainer/FriendlyAdornment.texture = playerCreature.adornmentAddon.sprite
	else:
		$FriendlyCollection/SpritesContainer/FriendlyAdornment.texture = null
	
	playerCreature.setupMoves()
	$EnemyCollection/EnemyHealthBar.max_value =enemy.maxHealth
	setHealth($EnemyCollection/EnemyHealthBar, enemy.currentHealth,  enemy.maxHealth)
	$EnemyCollection/EnemyTexture.texture = enemy.sprite
	enemy.setupMoves()
	$Textbox.hide()
	$Panel/MovesContainer.hide()
	display_text("A Wild enemy appears!")
	await textbox_closed
	$Panel.show()
	
	pass # Replace with function body.

func setupMoveMenu():
	var presentMoves = []
	$Panel/MovesContainer/BodyMove.text = playerCreature.currentCore.Move.name
	presentMoves.append(playerCreature.currentCore.Move.name)
	if (playerCreature.armsAddon != null):
		if(!playerCreature.armsAddon.name in presentMoves):
			$Panel/MovesContainer/ArmsMove.text = playerCreature.armsAddon.Move.name
			presentMoves.append(playerCreature.armsAddon.Move.name)
		else:
			$Panel/MovesContainer/ArmsMove.hide()
	else:
		$Panel/MovesContainer/ArmsMove.hide()
	if (!playerCreature.legsAddon != null):
		if(playerCreature.legsAddon.name in presentMoves):
			$Panel/MovesContainer/LegsMove.text = playerCreature.legsAddon.Move.name
			presentMoves.append(playerCreature.legsAddon.Move.name)
		else:
			$Panel/MovesContainer/LegsMove.hide()
	else:
		$Panel/MovesContainer/LegsMove.hide()
	if (playerCreature.adornmentAddon != null):
		if(!playerCreature.adornmentAddon.name in presentMoves):
			$Panel/MovesContainer/AdornmentMove.text = playerCreature.adornmentAddon.Move.name
			presentMoves.append(playerCreature.adornmentAddon.Move.name)
		else:
			$Panel/MovesContainer/AdornmentMove.hide()
	else:
		$Panel/MovesContainer/AdornmentMove.hide()
	pass


func _input(event):
	if(Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && textboxCooldown <=0):
		if($Textbox.visible):
			$Textbox.hide()
			textboxCooldown = baseTextboxCooldown
			emit_signal("textbox_closed")
		emit_signal("input_recieved")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(textboxCooldown >= 0):
		textboxCooldown -= delta
	pass

func display_text(text):
	$Textbox.show()
	$Textbox/Label.text = text


func _on_run_pressed():
	if (!allowButtons && textboxCooldown <=0):
		return
	display_text("Got away safely!")
	await textbox_closed
	await get_tree().create_timer(.25).timeout
	get_tree().change_scene_to_packed(Globals.previousScene)
	pass # Replace with function body.


func setHealth(progressBar, health, maxHealth):
	progressBar.value = health
	progressBar.max_value = maxHealth
	



func _on_fight_pressed():
	if (!allowButtons || textboxCooldown >=0):
		return
	allowButtons = false
	$Panel/ActionsContainer.hide()
	$Panel/MovesContainer.show()
	

	pass # Replace with function body.
	
func _on_body_move_pressed():
	combatRound("body")
	$Panel/MovesContainer.hide()
	$Panel/ActionsContainer.show()

func _on_arms_move_pressed():
	combatRound("arms")
	$Panel/MovesContainer.hide()
	$Panel/ActionsContainer.show()
	pass # Replace with function body.
func _on_legs_move_pressed():
	combatRound("legs")
	$Panel/MovesContainer.hide()
	$Panel/ActionsContainer.show()
	pass # Replace with function body.

func _on_adornment_move_pressed():
	combatRound("adornment")
	$Panel/MovesContainer.hide()
	$Panel/ActionsContainer.show()
	pass # Replace with function body.
	
func _on_return_pressed():
	$Panel/MovesContainer.hide()
	$Panel/ActionsContainer.show()
	allowButtons = true
	pass # Replace with function body.
	
func combatRound(move:String):
	if(playerCreature.speed >= enemy.speed):
		await playerTurn(move)
		await enemyTurn()
	else:
		await enemyTurn()
		await playerTurn(move)
	if(playerCreature.currentHealth == 0):
		#return to previous scene
		get_tree().quit()
	await input_recieved	
	allowButtons = true
	

func enemyTurn():
	var enemyMove:BaseMove = enemy.getMoves().pick_random()
	
	
	display_text("The %s attacks using %s" %[enemy.name, enemyMove.name])
	await textbox_closed
	playerCreature.currentHealth = max(0, playerCreature.currentHealth-calcDamage(enemyMove,enemy,playerCreature))
	enemyMove.seccondaryEffect(playerCreature, enemy)
	setHealth($FriendlyCollection/FriendlyHeathBar, playerCreature.currentHealth, playerCreature.maxHealth)

func playerTurn(move:String):
	var currentMove:BaseMove = null
	if(move == "body"):
		currentMove = playerCreature.currentCore.Move
	elif(move == "arms"):
		currentMove = playerCreature.armsAddon.Move
	elif(move == "legs"):
		currentMove = playerCreature.legsAddon.Move
	elif(move == "adornment"):
		currentMove = playerCreature.adornmentAddon.Move
	display_text("%s attacks using %s" %[playerCreature.name, currentMove.name])
	await textbox_closed

	#Player Damge
	
	enemy.currentHealth = max(0, enemy.currentHealth-calcDamage(currentMove,playerCreature,enemy))
	setHealth($EnemyCollection/EnemyHealthBar, enemy.currentHealth, enemy.maxHealth)
	currentMove.seccondaryEffect(enemy,playerCreature)
	setHealth($FriendlyCollection/FriendlyHeathBar, playerCreature.currentHealth, playerCreature.maxHealth)
	$AnimationPlayer.play("ShakeAnimation")
	await "animation_finished"
	await input_recieved
	if(enemy.currentHealth == 0):
		#return to previous scene
		get_tree().change_scene_to_packed(Globals.previousScene)


func calcDamage(move:BaseMove, user:BaseCreature, target:BaseCreature) -> int:
	var atk:float  = user.attack
	var def:float = target.defence
	var special:float = (50+user.special)/100.0 #-> 0.5x damage if no special stat, equal at 50, 1.5x at 100 , 2x at 150 etc
	if (!move.isSpecial):
		special = 1
	var power:int = move.baseDamage
	#typeBonus = 1+((0.5/4)*numMatchingParts) -> if all matching 1.5x boost
	var numMatchingParts = 0
	for addon in playerCreature.getCurrentAddons():
		if (addon.type == move.type):
			numMatchingParts +=1
	if (user.currentCore.type == move.type):
		numMatchingParts +=1
	var typeBonus:float = 1+((0.5/4)*numMatchingParts)
	
	var damage:float = (((atk/def)*special)*power*GENERAL_DAMAGE_INCREASE)*typeBonus
	print("ATk: %f" %atk)
	print("def: %f" %def)
	print("MoveIsSpecial: %s" %move.isSpecial)
	print("special: %f" %special)
	print("power: %f" %power)
	print("typeBonus: %f" %typeBonus)
	print("Damage: %f" %damage)
	print(" ")
	print(" ")
	return damage









