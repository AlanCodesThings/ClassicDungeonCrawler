bob_timer++;
if (!instance_exists(global.player_inst)) exit;
if (point_distance(x, y, global.player_inst.x, global.player_inst.y) < 24) {
    var p = global.player_inst;
    switch (pickup_type) {
        case 0: p.hp = min(p.max_hp, p.hp + value); break;
        case 1: p.damage += value; break;
        case 2: p.move_speed = min(p.move_speed + 0.3, 7.0); break;
    }
    instance_destroy();
}
