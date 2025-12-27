extends StaticBody2D

var can_interact: bool = false #player script turns on/off

@export var dialog_lines: Array[String] = ["Welcome!", "Nice weather we're having!", "Bye now!"]
var dialog_index: int = 0


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and can_interact: #both must be true
		$AudioStreamPlayer2D.play()
		if dialog_index < dialog_lines.size():
			$CanvasLayer.visible = true
			get_tree().paused = true
		
			$CanvasLayer/DialogLabel.text = dialog_lines[dialog_index]
			dialog_index += 1
			
		else:
			$CanvasLayer.visible = false
			get_tree().paused = false
			dialog_index = 0
