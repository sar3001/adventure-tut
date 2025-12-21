extends Area2D

var bodies_on_top: int = 0

@export var is_single_use: bool = false

signal pressed
signal unpressed


func _on_body_entered(body: Node2D) -> void:
	bodies_on_top += 1
	if body.is_in_group("pushable") or body is Player:
		if bodies_on_top == 1:
			pressed.emit()
			$AnimatedSprite2D.play("Pressed")


func _on_body_exited(body: Node2D) -> void:
	
	if is_single_use:
		return #if true, will not run the rest of the code
		
	bodies_on_top -= 1
	if body.is_in_group("pushable") or body is Player:
		if bodies_on_top == 0:
			unpressed.emit()
			$AnimatedSprite2D.play("Unpressed")
