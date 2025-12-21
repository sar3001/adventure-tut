extends CharacterBody2D
class_name Player

@export var move_speed: float = 100
@export var push_strength: float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if SceneManager.player_spawn_position != Vector2(0,0):
		position = SceneManager.player_spawn_position
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	move_player()

	push_blocks()
	
	move_and_slide() # must put this at the end of process. Function that takes velocity and applies it to move the player. Without it, velocity does nothing.

func move_player():
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
		
func push_blocks():
	
	# get the last collision
	# check if it's the block
	#if it is the block, push it
	
	var collision: KinematicCollision2D = get_last_slide_collision()
	
	if collision:
		
		var collider_node = collision.get_collider()
		
		# if collider_node is RigidBody2D:
		if collider_node.is_in_group("pushable"):
			var collision_normal: Vector2 = collision.get_normal()
			
			collider_node.apply_central_force(-collision_normal * push_strength)
