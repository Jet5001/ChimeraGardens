extends CharacterBody2D


const SPEED = 25.0
const SPRINTSPEEDMULTIPLIER = 1.75
const FRICTION = 0.85
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	player_movement(delta)
	# Add the gravity.

func player_movement(delta):
	velocity = velocity*FRICTION
	var addSpeed = SPEED
	if Input.is_key_pressed(KEY_SHIFT):
		addSpeed*=SPRINTSPEEDMULTIPLIER
	if Input.is_action_pressed("ui_right"):
		velocity.x += addSpeed
	if Input.is_action_pressed("ui_up"):
		velocity.y += -addSpeed
	if Input.is_action_pressed("ui_left"):
		velocity.x += -addSpeed
	if Input.is_action_pressed("ui_down"):
		velocity.y += addSpeed

	move_and_slide()

func _on_start_combat():
	await get_tree().create_timer(.01).timeout
	Globals.previousScene = PackedScene.new()
	Globals.previousScene.pack(get_parent())
	get_tree().change_scene_to_file("res://Scenes/TurnBasedCombat.tscn")
