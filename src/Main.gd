# Main.gd
extends Node2D

const ENEMY_PACKAGED_SCENE := preload("res://scenes/Enemy.tscn")
var enemy_spawn_timer := SimpleTimer.new(2.0, false)

onready var player : KinematicBody2D = $Player


func _ready() -> void:
    enemy_spawn_timer.connect("timeout", self, "_on_enemy_spawn_timer_timeout")
    add_child(enemy_spawn_timer)
    enemy_spawn_timer.start()

func _on_enemy_spawn_timer_timeout() -> void:
    var enemy_instance : KinematicBody2D = ENEMY_PACKAGED_SCENE.instance()
    var pos_value := 64
    var rand_position := Vector2(64, 64)
    var x_rand := randi() % 2
    var y_rand := randi() % 2
    if x_rand == 1:
        rand_position.x *= -1
    if y_rand == 1:
        rand_position.y *= -1
    enemy_instance.position = player.position + rand_position
    add_child(enemy_instance)
