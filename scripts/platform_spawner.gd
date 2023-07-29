extends Node2D

@export var platform_scene: PackedScene
@export var max_platform_count = 500
@export var platform_spacing = 300.0 * 0.75

@onready var camera: Camera2D = $"../Camera"
@onready var game_manager: GameManager = $".."
var last_y = ProjectSettings.get_setting("display/window/size/viewport_height", 1920) - 500

func _ready() -> void:
	$"../Camera/PlatformDestroyer".body_entered.connect(destroy_platform)
	for i in range(max_platform_count):
		spawn_platform()

func spawn_platform():
	goto_next_position()
	
	var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width", 1080)
	var platform = platform_scene.instantiate() as StaticBody2D
	var spring_path = platform.get_node("Path2D/PathFollow2D") as PathFollow2D
	
	platform.global_position = $"../Player/PlatformsMarker".global_position
	platform.position.x = randf_range(0, screen_width)
	
	# i tried setting spring_path.progress_ration but it didn't work, may be godot bug?
	spring_path.progress = randf_range(0, 237)
	if randf() < 0.9:
		spring_path.get_parent().queue_free()
	
	# I used call_deferred because without it compiler throws an error
	call_deferred("add_child", platform)
	
func goto_next_position():
	$"../Player/PlatformsMarker".global_position.y = last_y
	last_y -= platform_spacing
	
func destroy_platform(body):
	if body.is_in_group("player"):
		body.die()
		
	if body.is_in_group("platform"):
		spawn_platform()
		body.queue_free()
		game_manager.add_score()

