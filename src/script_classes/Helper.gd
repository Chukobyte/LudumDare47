# Helper.gd
extends Area2D

class_name Helper


static func is_convex(polygon : PoolVector2Array, base := 0) -> bool:
    var copied_polygon := PoolVector2Array(polygon)
    # Get starting info
    var p_sign := false
    var n := copied_polygon.size()
#    print_debug("Starting is_convex()")
#    print("size = %s" % str(n))
    if n < 3:
        
        return false
    for i in range(n):
        if i + 1 < n - 1:
            var old_position : Vector2 = copied_polygon[i]
            var new_position : Vector2 = copied_polygon[i+1]
            var p_cross : float = old_position.cross(new_position)
            if i == base:
                p_sign = p_cross > 0
            elif p_sign != (p_cross > 0):
                return false
    return true

static func is_position_inside_polygon(polygon : PoolVector2Array, inside_position : Vector2) -> bool:
    var inside := false
    print("is_position_inside_polygon")
    print("inside_position = %s" % str(inside_position))
    for p in polygon:
#        var dvec : Vector2 = (inside_position - p).normalized()
#        # rotate 90 degrees
#        var normal := Vector2(dvec.y, -dvec.x)
#        p.normalized()
#        var dot : float = p.cross(inside_position)
##        var dot := normal.dot(p)
#        print("dot = %s" % dot)
#        print("p = %s" % str(p))
#        if dot > 0:
#        print("p = %s" % str(p))
        var distance : float = p.distance_to(inside_position)
#        print("distance = %s" % str(distance))
        if distance < 0:
            inside = true
            print("BROKE")
            break
    print("inside = %s" % str(inside))
    return inside
