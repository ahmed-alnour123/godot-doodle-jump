class_name GameManager extends Node2D

const SCORE_FILE = "user://score_file.save"

var score = 0
var high_score = 0
@onready
var player: Player = get_tree().get_first_node_in_group("player")
@onready
var spawner = $PlatformSpawner
var game_started = false
@onready var main_menu = $MainMenu/MainMenu
@onready var about_menu = $MainMenu/AboutDev
@onready var lose_menu = $LoseMenu/LosePanel

func _ready() -> void:
	main_menu.get_node("Play").pressed.connect(start_game)
	lose_menu.get_node("Play").pressed.connect(restart_game)
	player.died.connect(end_game)
	player.set_physics_process(false)
	setup_about_dev_panel()
	connect_button_sounds()
	
	high_score = load_score()
	lose_menu.get_node("%BestScore").text = str(high_score)

func add_score():
	score += 1
	$HUD/ScoreLabel.text = str(score)
#	$Player/PipeAudioPlayer.play()

func start_game():
	game_started = true
	main_menu.hide()
	player.set_physics_process(true)
	
func restart_game():
	await get_tree().create_timer(0.1).timeout # to hear click sound
	get_tree().reload_current_scene()
	
func end_game():
	if score > high_score:
		save_score(score)
		lose_menu.get_node("%BestScore").text = str(score)
	lose_menu.get_node("%Score").text = str(score)
	lose_menu.show()
	
	
func load_score() -> int:
	print("loading high score...")
	var _score = 0
	if FileAccess.file_exists(SCORE_FILE):
		var file = FileAccess.open(SCORE_FILE, FileAccess.READ)
		var line = file.get_line()
		file.close()
		_score = int(line)
	print("hight score is ", _score)
	return _score
	
func save_score(player_score: int):
	print("saving high score...")
	var save_file = FileAccess.open(SCORE_FILE, FileAccess.WRITE)
	save_file.store_line(str(player_score))
	print("high score saved!!")

func setup_about_dev_panel():
	main_menu.get_node("About").pressed.connect(func(): about_menu.show())
	about_menu.get_node("%Exit").pressed.connect(func(): about_menu.hide())
	
	setup_social_media_button("%GithubButton", "https://github.com/ahmed-alnour123")
	setup_social_media_button("%TwitterButton", "https://twitter.com/ahmedalnour123")
	setup_social_media_button("%LinkedinButton", "https://linkedin.com/in/ahmedalnour123")
	setup_social_media_button("%EmailButton", "mailto:ahmed2699@gmail.com")
	
func setup_social_media_button(button: NodePath, url: String):
	about_menu.get_node(button).pressed.connect(
		func(): OS.shell_open(url)
	)

func _play_click_sound():
	$AudioPlayer.play()

func connect_button_sounds():
	about_menu.get_node("%Exit").pressed.connect(_play_click_sound)
	main_menu.get_node("About").pressed.connect(_play_click_sound)
	main_menu.get_node("Play").pressed.connect(_play_click_sound)
	lose_menu.get_node("Play").pressed.connect(_play_click_sound)
