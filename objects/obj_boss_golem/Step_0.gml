event_inherited();
if (!instance_exists(global.player_inst)) exit;
var px = global.player_inst.x, py = global.player_inst.y;
var dist = point_distance(x, y, px, py);
var dx = (px - x) / max(dist, 1), dy = (py - y) / max(dist, 1);
var nx = x + dx * move_speed + knockback_x, ny = y + dy * move_speed + knockback_y;
if (can_move_to(nx, y, col_half_w, col_half_h)) x = nx;
if (can_move_to(x, ny, col_half_w, col_half_h)) y = ny;
if (dist < col_half_w + 20 && attack_cd <= 0) {
    global.player_inst.take_damage(damage, x, y);
    attack_cd = attack_cd_max;
}
if (stomp_telegraph > 0) {
    stomp_telegraph--;
    if (stomp_telegraph == 0 && instance_exists(global.player_inst)) {
        if (point_distance(x, y, global.player_inst.x, global.player_inst.y) < 130)
            global.player_inst.take_damage(damage * 2, x, y);
    }
}
