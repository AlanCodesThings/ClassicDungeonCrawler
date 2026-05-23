// Charge at player
if (instance_exists(global.player_inst)) {
    var dist = point_distance(x, y, global.player_inst.x, global.player_inst.y);
    charge_dx = (global.player_inst.x - x) / max(dist, 1);
    charge_dy = (global.player_inst.y - y) / max(dist, 1);
    charge_speed = (phase == 1) ? 10 : 15;
    charge_active = true;
    alarm[3] = 55;
}
alarm[0] = (phase == 1) ? 260 : 190;
