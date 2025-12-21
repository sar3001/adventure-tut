extends StaticBody2D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		if $CanvasLayer.visible: #Checks of the boolian is true
			$CanvasLayer.visible = false
		else:
			$CanvasLayer.visible = true
