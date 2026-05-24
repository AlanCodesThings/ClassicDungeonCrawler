if (is_dead) exit;
// Visual timers (run every frame regardless of turn gate)
if (hit_flash > 0) hit_flash--;
if (move_anim_timer > 0) move_anim_timer--;

// Lerp visual position toward grid tile center
var _tx = grid_x * TILE_SIZE + TILE_SIZE / 2;
var _ty = grid_y * TILE_SIZE + TILE_SIZE / 2;
x = lerp(x, _tx, 0.18);
y = lerp(y, _ty, 0.18);
if (point_distance(x, y, _tx, _ty) > 1) { walk_t++; } else { walk_t = 0; }

// Update aim direction toward mouse
var _mdx = mouse_x - x;
var _mdy = mouse_y - y;
var _ml  = sqrt(_mdx * _mdx + _mdy * _mdy);
if (_ml > 10) { aim_dx = _mdx / _ml; aim_dy = _mdy / _ml; }

// Stairs detection — checked every frame but triggers on tile match
var do_descend = false;
with (obj_stairs) {
	if (grid_x == other.grid_x && grid_y == other.grid_y) {
		if (!global.boss_floor || global.boss_killed) do_descend = true;
	}
}
if (do_descend) {
	global.floor_number++;
	if (global.floor_number > 50) {
		global.won = true;
		global.player_inst = noone;
		room_goto(rm_class_select);
		exit;
	}
	global.cleaning_up = true;
	with (obj_enemy)      instance_destroy();
	with (obj_boss)       instance_destroy();
	with (obj_stairs)     instance_destroy();
	with (obj_arrow)      instance_destroy();
	with (obj_hitbox)     instance_destroy();
	with (obj_smoke_bomb) instance_destroy();
	with (obj_pickup)     instance_destroy();
	global.telegraph_tiles = [];
	global.smoke_tiles     = [];
	global.cleaning_up     = false;
	with (obj_dungeon_manager) {
		generate_dungeon(global.floor_number);
		other.grid_x = global.player_spawn_gx;
		other.grid_y = global.player_spawn_gy;
		other.x      = global.player_spawn_x;
		other.y      = global.player_spawn_y;
		render_map_surface();
	}
	exit;
}
