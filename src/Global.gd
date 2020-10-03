# Global.gd
extends Node2D


func _process(delta : float) -> void:
    if Input.is_action_just_pressed("ui_cancel"):
        get_tree().quit()
    if Input.is_action_just_pressed("ui_toggle_full_screen"):
        Window.set_fullscreen(!Window.is_full_screen())


func get_scene_tree() -> SceneTree:
    return get_tree()
