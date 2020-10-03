# TitleScreen.gd
extends Node2D


func _physics_process(delta):
    if Input.is_action_just_pressed("ui_accept"):
        get_tree().change_scene(ScenePaths.MAIN)
