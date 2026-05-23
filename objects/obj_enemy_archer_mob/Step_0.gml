if (!instance_exists(global.player_inst)) exit;
if (invincible_timer > 0) invincible_timer--;
if (hit_flash > 0) hit_flash--;
if (attack_cd > 0) attack_cd--;
if (pin_timer > 0) { pin_timer--; exit; }
knockback_x *= 0.75; knockback_y *= 0.75;
if (abs(knockback_x) < 0.1) knockback_x = 0;
if (abs(knockback_y) < 0.1) knockback_y = 0;
var px = global.player_inst.x, py = global.player_inst.y;
var dist = point_distance(x, y, px, py);
if (dist < aggro_range) {
    var dx = (px - x) / max(dist, 1), dy = (py - y) / max(dist, 1);
    if (dist < preferred_dist - 30) {
        // Back away from player
        var nx = x - dx * move_speed + knockback_x, ny = y - dy * move_speed + knockback_y;
        if (can_move_to(nx, y, col_half_w, col_half_h)) x = nx;
        if (can_move_to(x, ny, col_half_w, col_half_h)) y = ny;
    } else if (dist > preferred_dist + 30) {
        // Approach player
        var nx = x + dx * move_speed + knockback_x, ny = y + dy * move_speed + knockback_y;
        if (can_move_to(nx, y, col_half_w, col_half_h)) x = nx;
        if (can_move_to(x, ny, col_half_w, col_half_h)) y = ny;
    }
    if (dist < attack_range && attack_cd <= 0) {
        var a = instance_create_layer(x, y, "Instances", obj_enemy_projectile);
        a.dx = dx; a.dy = dy; a.spd = 5; a.dmg = damage;
        a.col = make_color_rgb(200, 80, 30); a.hw = 6; a.hh = 6;
        attack_cd = attack_cd_max;
    }
}
