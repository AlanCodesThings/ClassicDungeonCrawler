// Shadow dash — teleport near player and strike
if (instance_exists(global.player_inst)) {
    var px = global.player_inst.x, py = global.player_inst.y;
    x = px + irandom_range(-70, 70);
    y = py + irandom_range(-70, 70);
    if (point_distance(x, y, px, py) < 50) global.player_inst.take_damage(round(damage * 1.5), x, y);
}
alarm[0] = (phase == 1) ? 170 : 110;
