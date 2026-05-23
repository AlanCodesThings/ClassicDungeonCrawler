// Targeted volley at player
if (instance_exists(global.player_inst)) {
    var cnt = phase3 ? 8 : (phase == 2 ? 6 : 4);
    for (var i = 0; i < cnt; i++) {
        var ang = point_direction(x, y, global.player_inst.x, global.player_inst.y) + irandom_range(-28, 28);
        var a = instance_create_layer(x, y, "Instances", obj_enemy_projectile);
        a.dx = lengthdir_x(1, ang); a.dy = lengthdir_y(1, ang);
        a.spd = 7 + irandom(3); a.dmg = damage; a.col = make_color_rgb(255, 80, 0); a.hw = 10; a.hh = 10;
    }
}
alarm[1] = phase3 ? 85 : (phase == 2 ? 135 : 185);
