extends Control



func _on_StartButton_pressed():
	Global.goto_scene("res://Level/Level.tscn")


func _on_InstructionsButton_pressed():
	Global.goto_scene("res://MainMenu/Instructions.tscn")
