class_name Player extends CharacterBody2D

signal died

@export var SPEED = 300.0
@export var JUMP_VELOCITY = 800.0


var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
var screen_width: int = ProjectSettings.get_setting("display/window/size/viewport_width", 1080)
var dead = false

func _physics_process(delta: float) -> void:
		
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump()

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
#		velocity.x = direction * SPEED
		pass
	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
		pass
		
	if not dead:
		var mouse_pos = get_viewport().get_mouse_position()
#		if abs(position.x - mouse_pos.x) > 20:
#			if position.x < mouse_pos.x:
#				velocity.x = SPEED
#			else:
#				velocity.x = -SPEED
#		else:
#			velocity.x = 0
		position.x = clamp(mouse_pos.x, 0, screen_width)

	if move_and_slide():
		jump_from_platform()
		
func jump_from_platform():
	var collider = get_last_slide_collision().get_collider()
	if not collider.is_in_group("platform"): return
	jump()
	
func jump(jump_velocity = JUMP_VELOCITY):
	$Sprite.play("jump")
	$AudioPlayer.play()
	velocity.y = -jump_velocity

func play_spring_sound():
	$SpringSound.play()

func _on_visibility_notifier_screen_exited() -> void:
	if position.x <= 0:
		position.x = screen_width
	elif position.x >= screen_width:
		position.x = 0

func die():
	if dead: return
	dead = true
	SPEED = 0
	JUMP_VELOCITY = 0
	$Sprite.play("die")
	$FallSound.play()
	await get_tree().create_timer(2).timeout
	died.emit()
