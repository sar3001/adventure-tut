extends StaticBody2D


func _on_puzzle_button_pressed() -> void:
	print("Door: The puzzle button has been pressed!")
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)


func _on_puzzle_button_unpressed() -> void:
	print("Door: The puzzle button has been unpressed!")
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)
	
