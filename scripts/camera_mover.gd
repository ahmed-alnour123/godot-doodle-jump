extends Camera2D

## 0 means top of screen, 1 means bottom of screen
@export_range(0.0, 1.0) var player_screen_pos = 0.75
@onready var player = get_tree().get_first_node_in_group("player")
@onready var losing_ground_offset = $"../LosingGround".position.y - position.y
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height", 0)

var target_y = 0:
	set(new_y):
		if new_y < target_y or player.dead:
			target_y = new_y

func _process(_delta: float) -> void:
	target_y = player.position.y - screen_height * player_screen_pos
	position.y = target_y
	if not player.dead:
		$"../LosingGround".position.y = position.y + losing_ground_offset * 2
