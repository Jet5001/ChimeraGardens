extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_collision_shape_2d_child_entered_tree(node):
	print_debug("ENTERED")
	queue_free()
	get_tree().change_scene_to_file("res://Scenes/TurnBasedCombat.tscn")
	pass # Replace with function body.


func _on_area_2d_area_entered(area):
	print_debug("ENTERED")
	queue_free()
	get_tree().change_scene_to_file("res://Scenes/TurnBasedCombat.tscn")
	pass # Replace with function body.


func _on_body_entered(body):
	if body is CharacterBody2D:	
		body._on_start_combat()
		queue_free()


	pass # Replace with function body.
