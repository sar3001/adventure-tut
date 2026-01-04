extends CharacterBody2D

@export var speed: float = 30
@export var acceleration: float = 5
@export var HP: int = 2

var target: Node2D #null value; nothing is in it.


func _physics_process(delta: float) -> void:
	if HP <= 0: #stops slime from chasing player
		return
	
	chase_target()
		
	move_and_slide()
	
	animate_enemy()
	
func chase_target():
	if target: #if value is no longuer null
		var distance_to_player: Vector2
		distance_to_player = target.global_position - global_position

		var direction_normal = distance_to_player.normalized()
		
		#velocity = direction_normal * speed #this overwrites the knockback velocity in the player script.
		#speed instantly moves the object. this is where the object will end up.
		velocity = velocity.move_toward(direction_normal * speed, acceleration) #move_toward will move object over small increments. Acts like acceleration
		
func animate_enemy():
	var normal_velocity: Vector2 = velocity.normalized()
	#Vector2(10,10).normalized() (0.707, 0.707)
	#anything over 0.707 on x is greater than 1 so object will drift on x axis
	#anything over 0.707 on y is greater than 1 so object will move drift on y axis
	if normal_velocity.x > 0.707:
		#move right
		$AnimatedSprite2D.play("move_right")
	elif normal_velocity.x < -0.707:
		#move left, as numbers get smaller it moves left
		$AnimatedSprite2D.play("move_left")
	elif normal_velocity.y > 0.707:
		#move down
		$AnimatedSprite2D.play("move_down")
	elif normal_velocity.y < -0.707:
		#move up, as numbers get smaller it moves up in Godot
		$AnimatedSprite2D.play("move_up")
	
func _on_player_detect_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		
func take_damage():
	#copied from player script where "body" was referenced
	HP -= 1
	if HP <= 0:
		die()
		
	play_damage_sfx()
		
	var flash_red_color: Color = Color(10, 0, 0)
	modulate = flash_red_color
	
	await get_tree().create_timer(0.2).timeout
	
	#can't set the modulate back if slime is dead before .2 seconds, so:
	##if object is deleted in Godot, object is not null, so cannot wire "if object(body):"
	if is_instance_valid(self): #originally body in player script
		var original_color: Color = Color(1, 1, 1)
		modulate = original_color		

func play_damage_sfx():
	$DamageSFX.play()
	
func die():
	$GPUParticles2D.emitting = true
	$AnimatedSprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true) #use set deferred instead of call deferred
	
	
	await get_tree().create_timer(.8).timeout
	
	queue_free()
