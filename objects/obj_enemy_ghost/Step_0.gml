if (!instance_exists(global.player_inst)) exit;
if (invincible_timer > 0) invincible_timer--;
if (hit_flash > 0) hit_flash--;
if (attack_cd > 0) attack_cd--;
if (pin_timer > 0) { pin_timer--; exit; }
knockback_x *= 0.75; knockback_y *= 0.75;
if (abs(knockback_x) < 0.1) knockback_x = 0;
if (abs(knockback_y) < 0.1) knockback_y = 0;
// Randomly enter / exit phase
if (phase_timer > 0) {
    phase_timer--;
} else if (irandom(180) == 0) {
    phase_timer = 90;
}
var px = global.player_inst.x, py = global.player_inst.y;
var dist = point_distance(x, y, px, py);
if (dist < aggro_range) {
    var dx = (px - x) / max(dist, 1), dy = (py - y) / max(dist, 1);
    if (phase_timer > 0) {
        // Phase through walls
        x += dx * move_speed + knockback_x;
        y += dy * move_speed + knockback_y;
    } else {
        var nx = x + dx * move_speed + knockback_x, ny = y + dy * move_speed + knockback_y;
        if (can_move_to(nx, y, col_half_w, col_half_h)) x = nx;
        if (can_move_to(x, ny, col_half_w, col_half_h)) y = ny;
    }
    if (dist < attack_range && attack_cd <= 0) {
        global.player_inst.take_damage(damage, x, y);
        attack_cd = attack_cd_max;
    }
}
