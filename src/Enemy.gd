# Enemy.gd
extends KinematicBody2D


func _ready() -> void:
    add_to_group(GroupId.ENEMIES)
