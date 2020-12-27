extends Node2D


func _ready():
	pass # Replace with function body.


func open():
	$Sprite.frame = 1


func close():
	$Sprite.frame = 0
