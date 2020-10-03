# Main.gd
extends Node2D

const ENEMY_PACKAGED_SCENE := preload("res://scenes/Enemy.tscn")
const MAX_ENEMIES := 5
var spawned_enemies := 0
var enemy_spawn_timer := SimpleTimer.new(1.0)

onready var player : KinematicBody2D = $Player


func _ready() -> void:
    enemy_spawn_timer.connect("timeout", self, "_on_enemy_spawn_timer_timeout")
    add_child(enemy_spawn_timer)
    enemy_spawn_timer.start()

func _on_enemy_spawn_timer_timeout() -> void:
    var enemy_instance : KinematicBody2D = ENEMY_PACKAGED_SCENE.instance()
    enemy_instance.connect("destroyed", self, "_on_enemy_instance_destroyed")
    player.connect("turbo_triggered", enemy_instance, "_on_Player_turbo_triggered")
    player.connect("turbo_loop_enclosed", enemy_instance, "_on_Player_loop_enclosed")
    enemy_instance.player = player
    var pos_value := 64
    var rand_position := Vector2(128, 64)
#    var x_rand := randi() % 2
    var y_rand := randi() % 2
#    if x_rand == 1:
#        rand_position.x *= -1
    if y_rand == 1:
        rand_position.y *= -1
    enemy_instance.position = player.position + rand_position
    add_child(enemy_instance)
    spawned_enemies += 1
    if spawned_enemies < MAX_ENEMIES:
        enemy_spawn_timer.start()

func _on_enemy_instance_destroyed() -> void:
    spawned_enemies -= 1
    if enemy_spawn_timer.is_stopped():
        enemy_spawn_timer.start()
