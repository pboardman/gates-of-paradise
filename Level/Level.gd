extends Node2D

var score_mult = 10

# Subnodes
onready var door = $Door
onready var judgement_timer = $JudgementTimer
onready var start_timer = $StartCountdownTimer
onready var ui = $UI

# Sounds
onready var demon_laugh = $DemonLaugh
onready var holy_choir = $HolyChoir
onready var fire_sound = $FireSound

# Animations
onready var level_animation = $LevelAnimation
onready var animationTree = $LevelAnimation/AnimationTree
onready var animationState = animationTree.get("parameters/playback")
var animation_done = false

var soul


enum {
	PRE_GAME,
	START_COUNTDOWN,
	JUDGING,
	WAITING,
	WAITING_UNTIL_ANIM_END,
	SPAWN_NEXT_SOUL,
	POST_GAME_TRANSITION
}

var state = PRE_GAME


func _ready():
	# Seed the RNG functions
	randomize()
	
	animationTree.active = true
	
	# Set initial number of souls to judge
	ui.set_souls_left(30)


func _process(delta):
	print(state)
	match state:
		PRE_GAME:
			pre_game_state(delta)
		START_COUNTDOWN:
			start_countdown_state(delta)
		WAITING:
			waiting_state(delta)
		WAITING_UNTIL_ANIM_END:
			waiting_anim_end_state(delta)
		JUDGING:
			judging_state(delta)
		SPAWN_NEXT_SOUL:
			spawn_soul_state(delta)
		POST_GAME_TRANSITION:
			post_game_transition_state(delta)


func pre_game_state(delta):
	start_timer.start()
	state = START_COUNTDOWN


func start_countdown_state(delta):
	if start_timer.time_left != 0:
		ui.set_pre_game_countdown(ceil(start_timer.time_left))
	else:
		print("yo")
		ui.hide_pre_game_countdown()
		state = SPAWN_NEXT_SOUL


func waiting_state(delta):
	# Waiting for a soul to show up or something, maybe something will be needed here
	pass


func waiting_anim_end_state(delta):
	if animation_done:
		state = SPAWN_NEXT_SOUL


func judging_state(delta):
	ui.set_time_left(judgement_timer.time_left)
	if Input.is_action_just_pressed("open_gate"):
		door.open()
		_send_to_heaven()
	elif Input.is_action_just_pressed("send_to_hell"):
		_send_to_hell()


func spawn_soul_state(delta):
	soul = spawn_soul()
	ui.decrease_souls_left()
	judgement_timer.start()
	state = JUDGING

func post_game_transition_state(delta):
	# Wait for the player to make a choice
	ui.show_post_game_ui()
	state = WAITING


func spawn_soul():
	print("spawning a soul")
	var new_soul = load("res://Soul/Soul.tscn").instance()
	new_soul.position.x = 185
	new_soul.position.y = 350
	add_child(new_soul)
	return new_soul
	

func end_judgement():
	if ui.get_souls_left() != 0:
		soul.queue_free()
		door.close()
		state = WAITING_UNTIL_ANIM_END
	else:
		state = POST_GAME_TRANSITION


func set_animation_running():
	animation_done = false


func set_animation_done():
	animation_done = true


func _send_to_hell():
	"""
	Send the soul to hell
	"""
	state = WAITING
	animationState.travel("SendToHell")
	set_animation_running()
	
	if soul.is_demon:
		# PLAY SOME NICE MUSIC OR SOMETHING
		ui.increase_score(ceil(judgement_timer.time_left) * score_mult)
		fire_sound.play()
	else:
		ui.decrease_score(5 * score_mult)
		demon_laugh.play()
	
	judgement_timer.stop()
	
	end_judgement()

func _send_to_heaven():
	"""
	Send the soul to heaven
	"""
	state = WAITING
	animationState.travel("DoorOpen")
	set_animation_running()

	if not soul.is_demon:
		# PLAY SOME NICE MUSIC OR SOMETHING
		ui.increase_score(ceil(judgement_timer.time_left) * score_mult)
		holy_choir.play()
	else:
		ui.decrease_score(5 * score_mult)
		demon_laugh.play()
	
	judgement_timer.stop()
	
	end_judgement()
