class_name Player extends CharacterBody2D

signal died

@export var SPEED = 300.0
@export var JUMP_VELOCITY = 800.0


var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var screen_width: int = ProjectSettings.get_setting("display/window/size/viewport_width", 1080)
var dead = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump()

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if move_and_slide():
		jump_from_platform()
		
func jump_from_platform():
	var collider = get_last_slide_collision().get_collider()
	if not collider.is_in_group("platform"): return
	jump()
	
func jump(jump_velocity = JUMP_VELOCITY):
	velocity.y = -jump_velocity

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
	await get_tree().create_timer(3).timeout
	died.emit()
