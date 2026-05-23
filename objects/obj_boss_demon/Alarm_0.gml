// Rotating spiral burst
var spread = phase3 ? 24 : (phase == 2 ? 16 : 8);
for (var i = 0; i < spread; i++) {
    var ang = spiral_angle + i * (360 / spread);
    var a = instance_create_layer(x, y, "Instances", obj_enemy_projectile);
    a.dx = lengthdir_x(1, ang); a.dy = lengthdir_y(1, ang);
    a.spd = 6; a.dmg = round(damage * 0.6); a.col = make_color_rgb(200, 0, 0); a.hw = 9; a.hh = 9;
}
alarm[0] = phase3 ? 52 : (phase == 2 ? 78 : 105);
