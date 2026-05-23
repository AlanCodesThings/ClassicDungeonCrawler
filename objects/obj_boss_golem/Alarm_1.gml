if (instance_exists(global.player_inst)) {
    var px = global.player_inst.x, py = global.player_inst.y;
    var cnt = (phase == 1) ? 3 : 6;
    for (var i = 0; i < cnt; i++) {
        var ang = point_direction(x, y, px, py) + irandom_range(-45, 45);
        var a = instance_create_layer(x, y, "Instances", obj_enemy_projectile);
        a.dx = lengthdir_x(1, ang); a.dy = lengthdir_y(1, ang);
        a.spd = 6; a.dmg = damage; a.col = make_color_rgb(120, 100, 80); a.hw = 14; a.hh = 14;
    }
}
alarm[1] = (phase == 1) ? 220 : 150;
