# Enemy.gd
extends KinematicBody2D

var turbo_starting_angle := 0.0
var player_angle := 0.0

var track_player_turbo := false
var player : KinematicBody2D
var player_has_circled := false


func _ready() -> void:
    add_to_group(GroupId.ENEMIES)

func _process(delta : float) -> void:
    if track_player_turbo:
#        player_angle = rad2deg(player.position.angle_to(position))
        player_angle = player.position.angle_to_point(position)
        var angle_diff : float = abs(player_angle - turbo_starting_angle)
        print("player_angle = %s, angle diff = %s" % [str(player_angle), str(angle_diff)])
        if angle_diff >= PI:
            player_has_circled = true

func _on_Player_turbo_triggered() -> void:
#    turbo_starting_angle = rad2deg(player.position.angle_to(position))
    turbo_starting_angle = player.position.angle_to_point(position)
    track_player_turbo = true
    player_has_circled = false
    print("turbo_starting_angle = %s" % str(turbo_starting_angle))

func _on_Player_loop_enclosed() -> void:
    print("turbo_ending_angle = %s" % str(player_angle))
    track_player_turbo = false
    if player_has_circled:
        queue_free()
        player_has_circled = false
