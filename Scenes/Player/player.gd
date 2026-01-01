extends CharacterBody2D
class_name Player

@export var move_speed: float = 100
@export var push_strength: float = 10
@export var acceleration: float = 10

var is_attacking: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_treasure_label() #mkes sure label is updated if the player changes scenes
	update_hp_bar() #gets loaded during scene changes
	if SceneManager.player_spawn_position != Vector2(0,0):
		position = SceneManager.player_spawn_position
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	if not is_attacking:
		move_player()

	push_blocks()
	
	if Input.is_action_just_pressed("Interact"):
		attack()
	
	update_treasure_label()
	
	move_and_slide() # must put this at the end of process. Function that takes velocity and applies it to move the player. Without it, velocity does nothing.

func move_player():
	var move_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	#velocity = move_vector * move_speed # Best practice to use velocity to move the player. Don't use position. Both velocity and move_vector are Vec2
	velocity = velocity.move_toward(move_vector * move_speed, acceleration) #every frame, it will move the player over a period of time.
	#This is so that it can not immediately overwrite the velocit from "on hitbox area..." function.
	
	if velocity.x > 0:
		$AnimatedSprite2D.play("move_right")
		$InteractArea2D.position = Vector2(5, 2)
		
	elif velocity.x < 0:
		$AnimatedSprite2D.play("move_left")
		$InteractArea2D.position = Vector2(-5, 2)
		
	elif velocity.y < 0:
		$AnimatedSprite2D.play("move_up")
		$InteractArea2D.position = Vector2(0, -4)
		
	elif velocity.y > 0:
		$AnimatedSprite2D.play("move_down")
		$InteractArea2D.position = Vector2(0, 8)
		
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

func update_treasure_label():
	var treasure_amount: int = SceneManager.opened_chests.size()
	%TreasureLabel.text = str(treasure_amount) #default is an int, but .text needs to be a string

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		body.can_interact = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		body.can_interact = false


func _on_hitbox_area_2d_body_entered(body: Node2D) -> void:
	SceneManager.player_hp -= 1
	update_hp_bar()
	if SceneManager.player_hp <= 0:
		die()
		
	var distance_to_player: Vector2 = global_position - body.global_position #want to knock the player backwards (not forwards).
	var knockback_direction: Vector2 = distance_to_player.normalized()
	
	var knockback_strength: float = 200
	velocity += knockback_direction * knockback_strength
	
func die():
	SceneManager.player_hp = 3
	get_tree().reload_current_scene.call_deferred() # similar phrasing to scene entrance call_deferred

func update_hp_bar():
	if SceneManager.player_hp >= 3:
		%HpBar.play("3hp")
		
	elif SceneManager.player_hp == 2:
		%HpBar.play("2hp")
		
	elif SceneManager.player_hp == 1:
		%HpBar.play("1hp")
		
	else:
		%HpBar.play("0hp")
	
	
func attack():
	$Sword.visible = true
	%SwordArea2D.monitoring = true
	$AttackDurationTimer.start()
	
	is_attacking = true
	velocity = Vector2(0,0)
	
	var player_animation: String = $AnimatedSprite2D.animation
	if player_animation == "move_right":
		$AnimatedSprite2D.play("attack_right")
		$AnimationPlayer.play("attack_right")
	elif player_animation == "move_left":
		$AnimatedSprite2D.play("attack_left")
		$AnimationPlayer.play("attack_left")
	elif player_animation == "move_up":
		$AnimatedSprite2D.play("attack_up")
		$AnimationPlayer.play("attack_up")
	else:
		$AnimatedSprite2D.play("attack_down")
		$AnimationPlayer.play("attack_down")

func _on_sword_area_2d_body_entered(body: Node2D) -> void:
	#same as in slime_enemy script but switched. knockback direction is the same as players direction
	var distance_to_enemy: Vector2 = body.global_position - global_position #knocking the enemy backwards
	var knockback_direction: Vector2 = distance_to_enemy.normalized()
	
	var knockback_strength: float = 150
	
	body.velocity += knockback_direction * knockback_strength
	body.HP -= 1
	if body.HP <= 0:
		body.queue_free()


func _on_attack_duration_timer_timeout() -> void:
	$Sword.visible = false
	%SwordArea2D.monitoring = false
	is_attacking = false
	
	var player_animation: String = $AnimatedSprite2D.animation
	if player_animation == "attack_right":
		$AnimatedSprite2D.play("move_right")
	elif player_animation == "attack_left":
		$AnimatedSprite2D.play("move_left")
	elif player_animation == "attack_up":
		$AnimatedSprite2D.play("move_up")
	else:
		$AnimatedSprite2D.play("move_down")
