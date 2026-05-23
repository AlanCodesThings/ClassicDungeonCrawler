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
// Death zone tick damage
for (var i = array_length(death_zones) - 1; i >= 0; i--) {
    var dz = death_zones[i];
    dz.timer--;
    if (instance_exists(global.player_inst) && point_distance(global.player_inst.x, global.player_inst.y, dz.x, dz.y) < dz.r)
        global.player_inst.take_damage(round(damage * 0.15), dz.x, dz.y);
    if (dz.timer <= 0) array_delete(death_zones, i, 1);
}
// Phase 2: life steal
if (phase == 2 && attack_cd <= 0) hp = min(max_hp, hp + 1);
