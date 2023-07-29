extends Area2D


@onready var player: Player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if overlaps_body(player) and player.velocity.y > 0:
		player.jump(player.JUMP_VELOCITY * 1.2)
		player.play_spring_sound()
