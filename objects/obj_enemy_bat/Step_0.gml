if (!instance_exists(global.player_inst)) exit;
if (invincible_timer > 0) invincible_timer--;
if (hit_flash > 0) hit_flash--;
if (attack_cd > 0) attack_cd--;
if (pin_timer > 0) { pin_timer--; exit; }
knockback_x *= 0.7; knockback_y *= 0.7;
if (abs(knockback_x) < 0.1) knockback_x = 0;
if (abs(knockback_y) < 0.1) knockback_y = 0;
var px = global.player_inst.x, py = global.player_inst.y;
var dist = point_distance(x, y, px, py);
if (dist > 1) {
    x += ((px - x) / dist) * move_speed + knockback_x;
    y += ((py - y) / dist) * move_speed + knockback_y;
}
x = clamp(x, 8, room_width  - 8);
y = clamp(y, 8, room_height - 8);
if (dist < attack_range && attack_cd <= 0) {
    global.player_inst.take_damage(damage, x, y);
    attack_cd = attack_cd_max;
}
