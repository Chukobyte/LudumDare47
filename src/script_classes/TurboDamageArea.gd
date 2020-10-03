# TurboDamageArea.gd
extends Area2D

class_name TurboDamageArea

const POLYGON_COLOR := Color.red

var polygon2d := Polygon2D.new()
var collision := CollisionPolygon2D.new()
var life_timer := SimpleTimer.new(0.2)


func _init(polygon : PoolVector2Array, polygon_connected_index : int):
#    print("Turbo Damage area connected index = %s" % str(polygon_connected_index))
#    for i in range(polygon_connected_index):
#        print("removed = %s" % polygon[i])
#        polygon.remove(i)
    polygon2d.polygon = polygon
    polygon2d.color = POLYGON_COLOR
#    polygon2d.visible = false
#    collision.visible = true

func _ready() -> void:
    connect("body_entered", self, "_on_Area2D_body_entered")
    life_timer.connect("timeout", self, "_on_life_timer_timeout")
#    add_child(collision)
#    call_deferred("add_child", collision)
    add_child(life_timer)
    life_timer.start()
    add_child(polygon2d)
#    collision.polygon = polygon2d.polygon
#    var space := get_world_2d().get_direct_space_state()
#    var shape_query := Physics2DShapeQueryParameters.new()
#    shape_query.set_shape(collision)
#    var results = space.intersect_shape(shape_query)
#    print("result size = %s" % str(results.size()))
#    for result in results:
#        print("result = %s" % str(result))

func _on_Area2D_body_entered(body : Node) -> void:
    print("%s entered damage area!" % body.get_name())
    if body.is_in_group(GroupId.ENEMIES):
#        body.queue_free()
        pass

func _on_life_timer_timeout() -> void:
    queue_free()
