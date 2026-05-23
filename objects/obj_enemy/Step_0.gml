if (!instance_exists(global.player_inst)) exit;
if (invincible_timer > 0) invincible_timer--;
if (hit_flash > 0) hit_flash--;
if (attack_cd > 0) attack_cd--;
// Pinned — skip movement and attack
if (pin_timer > 0) { pin_timer--; exit; }
// Knockback
knockback_x *= 0.75; knockback_y *= 0.75;
if (abs(knockback_x) < 0.15) knockback_x = 0;
if (abs(knockback_y) < 0.15) knockback_y = 0;
var px = global.player_inst.x, py = global.player_inst.y;
var dist = point_distance(x, y, px, py);
if (dist < aggro_range) {
	var dx = (px - x) / max(dist, 1), dy = (py - y) / max(dist, 1);
	var nx = x + dx * move_speed + knockback_x;
	var ny = y + dy * move_speed + knockback_y;
	if (can_move_to(nx, y, col_half_w, col_half_h)) x = nx;
	if (can_move_to(x, ny, col_half_w, col_half_h)) y = ny;
	if (dist < attack_range && attack_cd <= 0) {
		global.player_inst.take_damage(damage, x, y);
		attack_cd = attack_cd_max;
	}
}
