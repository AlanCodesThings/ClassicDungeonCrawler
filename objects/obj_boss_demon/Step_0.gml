event_inherited();
if (!phase3 && hp < max_hp * 0.33) { phase3 = true; on_phase3(); }
if (!instance_exists(global.player_inst)) exit;
var px = global.player_inst.x, py = global.player_inst.y;
var dist = point_distance(x, y, px, py);
var dx = (px - x) / max(dist, 1), dy = (py - y) / max(dist, 1);
var nx = x + dx * move_speed + knockback_x, ny = y + dy * move_speed + knockback_y;
if (can_move_to(nx, y, col_half_w, col_half_h)) x = nx;
if (can_move_to(x, ny, col_half_w, col_half_h)) y = ny;
if (dist < col_half_w + 16 && attack_cd <= 0) {
    global.player_inst.take_damage(damage, x, y);
    attack_cd = 50;
}
spiral_angle += (phase3 ? 4 : (phase == 2 ? 2.5 : 1.5));
