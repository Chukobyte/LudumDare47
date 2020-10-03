# Main.gd
extends Node2D

const ENEMY_PACKAGED_SCENE := preload("res://scenes/Enemy.tscn")
const ENEMIES_TO_SPAWN := 20
var spawned_enemies := 0
var enemy_spawn_timer := SimpleTimer.new(2.0)

onready var player : KinematicBody2D = $Player
onready var enemy : KinematicBody2D = $Enemy


func _ready() -> void:
    enemy_spawn_timer.connect("timeout", self, "_on_enemy_spawn_timer_timeout")
    player.connect("turbo_triggered", enemy, "_on_Player_turbo_triggered")
    player.connect("turbo_loop_enclosed", enemy, "_on_Player_loop_enclosed")
    enemy.player = player
    add_child(enemy_spawn_timer)
    enemy_spawn_timer.start()

func _on_enemy_spawn_timer_timeout() -> void:
    var enemy_instance : KinematicBody2D = ENEMY_PACKAGED_SCENE.instance()
    player.connect("turbo_triggered", enemy_instance, "_on_Player_turbo_triggered")
    player.connect("turbo_loop_enclosed", enemy_instance, "_on_Player_loop_enclosed")
    enemy_instance.player = player
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
    spawned_enemies += 1
    if spawned_enemies < ENEMIES_TO_SPAWN:
        enemy_spawn_timer.start()
