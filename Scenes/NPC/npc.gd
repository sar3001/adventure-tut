extends StaticBody2D

var can_interact: bool = true


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and can_interact: #both must be true
		if $CanvasLayer.visible: #Checks of the boolian is true
			$CanvasLayer.visible = false
		else:
			$CanvasLayer.visible = true
