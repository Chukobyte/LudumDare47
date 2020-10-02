# Global.gd
extends Node2D


func _process(delta : float) -> void:
    if Input.is_action_just_pressed("ui_cancel"):
        get_tree().quit()

func get_scene_tree() -> SceneTree:
    return get_tree()
