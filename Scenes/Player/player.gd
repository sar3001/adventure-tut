extends CharacterBody2D
class_name Player

@export var move_speed: float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(move_speed)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = move_vector * move_speed # Best practice to use velocity to move the player. Don't use position. Both velocity and move_vector are Vec2
	
	if velocity.x > 0:
		$AnimatedSprite2D.play("move_right")
		
	elif velocity.x < 0:
		$AnimatedSprite2D.play("move_left")
		
	elif velocity.y < 0:
		$AnimatedSprite2D.play("move_up")
		
	elif velocity.y > 0:
		$AnimatedSprite2D.play("move_down")
		
	else:
		$AnimatedSprite2D.stop()
		
	#elif velocity == Vector2(0,0): # alterternative way to write the above statement
		#$AnimatedSprite2D.stop
	
	move_and_slide() # must put this at the end of process. Function that takes velocity and applies it to move the player. Without it, velocity does nothing.
