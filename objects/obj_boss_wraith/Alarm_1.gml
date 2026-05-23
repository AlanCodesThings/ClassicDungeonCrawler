// Shadow hands — projectiles from ring converging on player
if (instance_exists(global.player_inst)) {
    var cnt = (phase == 1) ? 5 : 9;
    var px = global.player_inst.x, py = global.player_inst.y;
    for (var i = 0; i < cnt; i++) {
        var ang = i * (360 / cnt);
        var ox = x + lengthdir_x(130, ang), oy = y + lengthdir_y(130, ang);
        var pd = point_distance(ox, oy, px, py);
        var a = instance_create_layer(ox, oy, "Instances", obj_enemy_projectile);
        a.dx = (px - ox) / max(pd, 1); a.dy = (py - oy) / max(pd, 1);
        a.spd = 4; a.dmg = round(damage * 0.6); a.col = make_color_rgb(50, 0, 80); a.hw = 12; a.hh = 12;
    }
}
alarm[1] = (phase == 1) ? 210 : 155;
