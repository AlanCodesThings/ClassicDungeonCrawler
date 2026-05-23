if (!instance_exists(global.player_inst)) exit;
if (invincible_timer > 0) invincible_timer--;
if (hit_flash > 0) hit_flash--;
if (attack_cd > 0) attack_cd--;
if (teleport_cd > 0) teleport_cd--;
if (pin_timer > 0) { pin_timer--; exit; }
knockback_x *= 0.75; knockback_y *= 0.75;
if (abs(knockback_x) < 0.1) knockback_x = 0;
if (abs(knockback_y) < 0.1) knockback_y = 0;
var px = global.player_inst.x, py = global.player_inst.y;
var dist = point_distance(x, y, px, py);
// Teleport away if player too close
if (dist < 90 && teleport_cd <= 0) {
    var ang = point_direction(px, py, x, y) + irandom_range(-30, 30);
    var nx = px + lengthdir_x(210, ang), ny = py + lengthdir_y(210, ang);
    if (can_move_to(nx, ny, col_half_w, col_half_h)) { x = nx; y = ny; }
    teleport_cd = 180;
}
if (dist < aggro_range) {
    var dx = (px - x) / max(dist, 1), dy = (py - y) / max(dist, 1);
    if (dist > preferred_dist + 30) {
        var nx = x + dx * move_speed + knockback_x, ny = y + dy * move_speed + knockback_y;
        if (can_move_to(nx, y, col_half_w, col_half_h)) x = nx;
        if (can_move_to(x, ny, col_half_w, col_half_h)) y = ny;
    }
    if (dist < attack_range && attack_cd <= 0) {
        // 3-way spread
        var base_ang = point_direction(x, y, px, py);
        for (var i = -1; i <= 1; i++) {
            var ang = base_ang + i * 18;
            var a = instance_create_layer(x, y, "Instances", obj_enemy_projectile);
            a.dx = lengthdir_x(1, ang); a.dy = lengthdir_y(1, ang);
            a.spd = 4; a.dmg = damage;
            a.col = make_color_rgb(100, 0, 200); a.hw = 8; a.hh = 8;
        }
        attack_cd = attack_cd_max;
    }
}
