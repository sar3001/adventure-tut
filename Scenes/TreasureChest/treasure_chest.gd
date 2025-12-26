extends StaticBody2D

var can_interact: bool = false
var is_open: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and can_interact:
		if not is_open: # do not need to close chest once it is open
			open_chest()
			

func open_chest():
	is_open = true
	$AnimatedSprite2D.play("open")
	$Sprite2D.visible = true
	$Timer.start()


func _on_timer_timeout() -> void:
	$Sprite2D.visible = false
