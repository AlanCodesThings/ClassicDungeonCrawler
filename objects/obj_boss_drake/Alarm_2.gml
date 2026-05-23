// Phase 2: delayed ice bombs around room
for (var i = 0; i < 6; i++) {
    var tx = x + irandom_range(-220, 220), ty = y + irandom_range(-220, 220);
    var a = instance_create_layer(tx, ty, "Instances", obj_enemy_projectile);
    a.dx = 0; a.dy = 0; a.spd = 0; a.dmg = damage;
    a.col = make_color_rgb(150, 220, 255); a.hw = 20; a.hh = 20; a.life_timer = 90;
}
alarm[2] = 190;
