// Phase 2: outward shockwave ring
for (var i = 0; i < 12; i++) {
    var ang = i * 30;
    var a = instance_create_layer(x, y, "Instances", obj_enemy_projectile);
    a.dx = lengthdir_x(1, ang); a.dy = lengthdir_y(1, ang);
    a.spd = 5; a.dmg = round(damage * 0.7); a.col = make_color_rgb(150, 120, 80); a.hw = 10; a.hh = 10;
}
alarm[2] = 160;
