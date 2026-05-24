var dist = point_distance(x, y, target_x, target_y);
if (dist <= speed_px) { instance_destroy(); exit; }
x += dx * speed_px;
y += dy * speed_px;
