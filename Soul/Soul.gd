extends Node2D


onready var is_demon = roll_for_demon()


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_soul()


func generate_soul():
	"""
	Generate a 2D model for the soul
	"""
	var texture
	if is_demon:
		texture = load("res://Soul/placeholderSoul.png")
	else:
		texture = load("res://Soul/placeholderSoulAngel.png")
		
	$Sprite.set_texture(texture)


func roll_for_demon():
	"""
	roll to check if this soul will be a demon
	"""
	var percent = randf()
	if (percent > 0.5):
		return true
	return false
