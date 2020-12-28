extends Node2D


onready var is_demon = roll()

onready var demon_parts = [
	$DevilWing,
	$DevilTail,
	$DevilHorns
]

onready var angel_parts = [
	$AngelWing,
	$AngelHalo
]

onready var demon_wing = $DevilWing
onready var angel_wing = $AngelWing

onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_soul()


func generate_soul():
	"""
	Generate a 2D model for the soul
	"""
	
	# Roll for angel parts
	for parts in angel_parts:
		if roll():
			parts.visible = true

	# Roll for demon parts
	if is_demon:
		_generate_demon()


func _generate_demon():
	demon_parts[randi()%demon_parts.size()].visible = true
	
	# Can't have both wing at once
	if demon_wing.visible:
		angel_wing.visible = false
		

func go_to_paradise():
	animation_player.play("ToHeaven")


func go_to_hell():
	animation_player.play("ToHell")


func roll():
	"""
	roll to check if this soul will be a demon
	"""
	var percent = randf()
	if (percent > 0.5):
		return true
	return false


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
