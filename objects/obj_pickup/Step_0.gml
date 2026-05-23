if (!instance_exists(global.player_inst)) exit;
var p = global.player_inst;
if (grid_x == p.grid_x && grid_y == p.grid_y) {
	switch (pickup_type) {
		case 0: p.hp = min(p.max_hp, p.hp + value); break;
		case 1: p.damage += value; break;
		case 2: p.hp = min(p.max_hp, p.hp + value); break; // speed_up → extra heal in grid mode
	}
	instance_destroy();
}
