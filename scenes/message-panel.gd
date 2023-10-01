extends PanelContainer

var game_started = false

func _ready():
	$TextBox/VBoxContainer/Validate.connect("button_up", manage_button_click)
	GameManager.connect("game_over", _show_game_over_text)
	
func manage_button_click():
	if game_started:
		$TextBox/VBoxContainer/Exit.visible = false
		GameManager.restart()
		get_tree().reload_current_scene()
	else:
		launch_game()

func launch_game():
	self.visible = false
	game_started = true
	GameManager.start_game()

func _show_game_over_text():
	self.visible = true
	$TextBox/VBoxContainer/RichTextLabel.text = _get_game_over_message()
	$TextBox/VBoxContainer/Validate.text = "No, I cannot believe it!"
	$TextBox/VBoxContainer/Exit.visible = true
	$TextBox/VBoxContainer/Exit.text = "I'll see myself out..."
	$TextBox/VBoxContainer/Exit.connect("button_up", _quit_game)

func _get_game_over_message():
	return "Supervisor, it's [b]over[/b]. Your failures echo through our once-thriving haven. %s citizens, %s waves of refugees—[b]all lost[/b]. Shadows have claimed our last light." % [str(GameManager.population), str(GameManager.wave)]

func _quit_game():
	get_tree().quit()
