event_inherited();
if (!instance_exists(global.player_inst)) exit;
if (invis_timer > 0) invis_timer--;
if (teleport_cd > 0) teleport_cd--;
var px = global.player_inst.x, py = global.player_inst.y;
var dist = point_distance(x, y, px, py);
if (dist > 55) {
    var dx = (px - x) / dist, dy = (py - y) / dist;
    var nx = x + dx * move_speed + knockback_x, ny = y + dy * move_speed + knockback_y;
    if (can_move_to(nx, y, col_half_w, col_half_h)) x = nx;
    if (can_move_to(x, ny, col_half_w, col_half_h)) y = ny;
}
if (dist < 55 && attack_cd <= 0) {
    global.player_inst.take_damage(damage, x, y);
    attack_cd = 80;
}
