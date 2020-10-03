# Player.gd
extends KinematicBody2D

signal turbo_triggered()
signal turbo_loop_enclosed()

const UP_DIRECTION := Vector2(0, 0)
const TURBO_TRAIL_PACKED_SCENE := preload("res://scenes/TurboTrail.tscn")

var max_speed := 90
var acceleration := 15
var deceleration := Vector2(0.05, 0.05)
var velocity := Vector2(0, 0)

var animation_move_down := "MoveDown"
var animation_move_up := "MoveUp"
var animation_move_left := "MoveLeft"
var animation_move_right := "MoveRight"

#var turbo_trail_spawn_timer := SimpleTimer.new(0.02)
var turbo_trail_spawn_timer := SimpleTimer.new(0.1)
var turbo_trail_positions := PoolVector2Array()

onready var animated_sprite : AnimatedSprite = $AnimatedSprite

var has_turbo := false


func _ready() -> void:
    add_to_group(GroupId.PLAYERS)
    turbo_trail_spawn_timer.connect("timeout", self, "_on_turbo_trail_spawn_timer_timeout")
    add_child(turbo_trail_spawn_timer)

func _process(delta : float) -> void:
    if Input.is_action_pressed("ui_turbo"):
        if !has_turbo:
            emit_signal("turbo_triggered")
        has_turbo = true
        if turbo_trail_spawn_timer.is_stopped():
            turbo_trail_spawn_timer.start()
            _on_turbo_trail_spawn_timer_timeout()
    if Input.is_action_just_released("ui_turbo"):
        has_turbo = false
        turbo_trail_positions.resize(0)
        for turbo_trail in get_tree().get_nodes_in_group(GroupId.TURBO_TRAILS):
            turbo_trail.call_deferred("queue_free")

func _physics_process(delta : float):
    _update_velocity_from_input()
    velocity = move_and_slide(velocity, UP_DIRECTION)

func _update_velocity_from_input() -> void:
    var movement_acceleration := acceleration
    var movement_max_speed := max_speed
    if has_turbo:
        movement_acceleration *= 2.5
        movement_max_speed *= 2.5

    if Input.is_action_pressed("ui_move_right"):
        velocity.x = min(velocity.x + movement_acceleration, movement_max_speed)
        animated_sprite.play(animation_move_right)
    elif Input.is_action_pressed("ui_move_left"):
        velocity.x = max(velocity.x - movement_acceleration, -movement_max_speed)
        animated_sprite.play(animation_move_left)
    else :
        velocity.x = lerp(velocity.x, 0, deceleration.x)

    if Input.is_action_pressed("ui_move_down"):
        velocity.y = min(velocity.y + movement_acceleration, movement_max_speed)
        animated_sprite.play(animation_move_down)
    elif Input.is_action_pressed("ui_move_up"):
        velocity.y = max(velocity.y - movement_acceleration, -movement_max_speed)
        animated_sprite.play(animation_move_up)
    else:
        velocity.y = lerp(velocity.y, 0, deceleration.y)

func _on_turbo_trail_spawn_timer_timeout() -> void:
    if has_turbo:
        var turbo_trail : Node2D = TURBO_TRAIL_PACKED_SCENE.instance()
        turbo_trail.connect("enclosed", self, "_on_TurboTrail_enclosed")
        turbo_trail.position = position
        turbo_trail.position_array_index = turbo_trail_positions.size()
        turbo_trail_positions.append(position)
        get_tree().get_current_scene().add_child(turbo_trail)

func _on_TurboTrail_enclosed(position_connected : int) -> void:
    for turbo_trail in get_tree().get_nodes_in_group(GroupId.TURBO_TRAILS):
        turbo_trail.call_deferred("queue_free")
#    for enemy in get_tree().get_nodes_in_group(GroupId.ENEMIES):
#        if Helper.is_position_inside_polygon(turbo_trail_positions, enemy.position):
#            enemy.queue_free()
#    var is_convex := Helper.is_convex(turbo_trail_positions)
#    print("is_convex = %s" % str(is_convex))
#    if !is_convex:
#        return
#    if !turbo_trail_positions.empty():
#        for i in position_connected:
#            turbo_trail_positions.remove(i)
#    if turbo_trail_positions.size() >= 3:
#        var turbo_damage_area := TurboDamageArea.new(turbo_trail_positions, position_connected)
#        get_tree().get_current_scene().add_child(turbo_damage_area)
    emit_signal("turbo_loop_enclosed")
    turbo_trail_positions.resize(0)
    turbo_trail_spawn_timer.stop()
