# Init.gd
extends Node


func _ready() -> void:
    Window.center()
    get_tree().change_scene(ScenePaths.TITLE_SCREEN)
