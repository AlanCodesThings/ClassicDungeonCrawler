event_inherited();
if (!instance_exists(global.player_inst)) exit;
if (breath_timer > 0) {
    breath_timer--;
    if (breath_timer mod 5 == 0 && instance_exists(global.player_inst)) {
        var ang = point_direction(x, y, global.player_inst.x, global.player_inst.y) + irandom_range(-22, 22);
        var a = instance_create_layer(x, y, "Instances", obj_enemy_projectile);
        a.dx = lengthdir_x(1, ang); a.dy = lengthdir_y(1, ang);
        a.spd = 7; a.dmg = round(damage * 0.5); a.col = make_color_rgb(100, 180, 255); a.hw = 10; a.hh = 10;
    }
}
if (!charge_active) {
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
} else {
    var hit_wall = false;
    var nx = x + charge_dx * charge_speed, ny = y + charge_dy * charge_speed;
    if (can_move_to(nx, y, col_half_w, col_half_h)) x = nx; else hit_wall = true;
    if (can_move_to(x, ny, col_half_w, col_half_h)) y = ny; else hit_wall = true;
    if (hit_wall) charge_active = false;
    if (instance_exists(global.player_inst) && point_distance(x, y, global.player_inst.x, global.player_inst.y) < col_half_w + 20)
        global.player_inst.take_damage(damage * 2, x, y);
}
