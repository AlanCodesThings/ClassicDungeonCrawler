// Plague bomb — lands near player after a delay (stationary projectile)
if (instance_exists(global.player_inst)) {
    var tx = global.player_inst.x + irandom_range(-70, 70);
    var ty = global.player_inst.y + irandom_range(-70, 70);
    var a = instance_create_layer(tx, ty, "Instances", obj_enemy_projectile);
    a.dx = 0; a.dy = 0; a.spd = 0; a.dmg = damage;
    a.col = make_color_rgb(50, 180, 0); a.hw = 26; a.hh = 26; a.life_timer = 55;
    array_push(death_zones, { x: tx, y: ty, r: 80, timer: 320 });
}
alarm[1] = (phase == 1) ? 230 : 165;
