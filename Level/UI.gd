extends Control

onready var score = $Score
onready var time_left = $TimeLeft
onready var soul_left = $SoulLeft
onready var post_game_ui = $PostgameUI
onready var final_score = $PostgameUI/FinalScoreLabel
onready var pre_game_countdown = $PreGameCountdown
onready var score_show_label = $ScoreShowLabel

var souls_left = 0

func _ready():
	score.text = "Score: 0"
	time_left.text = "Time to judge: N/A"
	soul_left.text = "Soul left: "

	pre_game_countdown.visible = true
	post_game_ui.visible = false

func increase_score(value):
	score.text = "Score: " + str(int(score.text) + int(value))
	_show_score_increase(value)


func decrease_score(value):
	score.text = "Score: " + str(int(score.text) - value)
	_show_score_decrease(value)


func set_time_left(value):
	time_left.text = "Time to judge: " + str(stepify(value, 0.1))


func set_souls_left(value):
	souls_left = value
	soul_left.text = "Soul left: " + str(souls_left)


func decrease_souls_left():
	souls_left -= 1
	soul_left.text = "Soul left: " + str(souls_left)


func get_souls_left():
	return souls_left


func set_pre_game_countdown(value):
	pre_game_countdown.text = str(value)
	

func hide_pre_game_countdown():
	pre_game_countdown.visible = false


func _show_score_decrease(value):
	score_show_label.text = "-" + str(value)
	var animation_player = score_show_label.get_node("AnimationPlayer")
	animation_player.stop()
	animation_player.play("FadeTextRed")


func _show_score_increase(value):
	score_show_label.text = "+" + str(value)
	var animation_player = score_show_label.get_node("AnimationPlayer")
	animation_player.stop()
	animation_player.play("FadeTextGreen")

func show_post_game_ui():
	final_score.text = "Final Score\n" + score.text.split(":")[-1].strip_edges()
	post_game_ui.visible = true


func _on_PlayAgainButton_pressed():
	Global.goto_scene("res://Level/Level.tscn")


func _on_MainMenuButton_pressed():
	Global.goto_scene("res://MainMenu/MainMenu.tscn")
