// Phase 3: ground slam + shockwave ring
if (instance_exists(global.player_inst) && point_distance(x, y, global.player_inst.x, global.player_inst.y) < 210)
    global.player_inst.take_damage(damage * 3, x, y);
for (var i = 0; i < 20; i++) {
    var ang = i * 18;
    var a = instance_create_layer(x, y, "Instances", obj_enemy_projectile);
    a.dx = lengthdir_x(1, ang); a.dy = lengthdir_y(1, ang);
    a.spd = 8; a.dmg = round(damage * 0.8); a.col = c_red; a.hw = 12; a.hh = 12;
}
alarm[3] = 210;
