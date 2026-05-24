if (is_dead) exit;

// Frame timers
if (hit_flash        > 0) hit_flash--;
if (invincible_timer > 0) invincible_timer--;
if (move_cd          > 0) move_cd--;
if (attack_cd        > 0) attack_cd--;
if (ability_dash_cd > 0) ability_dash_cd--;
if (ability_util_cd > 0) ability_util_cd--;
if (ability_dmg_cd  > 0) ability_dmg_cd--;
if (ability_ult_cd  > 0) ability_ult_cd--;

// Constant-speed slide toward grid tile center (Pokémon-style)
var _tx = grid_x * TILE_SIZE + TILE_SIZE / 2;
var _ty = grid_y * TILE_SIZE + TILE_SIZE / 2;
var _spd = TILE_SIZE / 10; // 3.2 px/frame — one tile in 10 frames, matching move_cd
x += clamp(_tx - x, -_spd, _spd);
y += clamp(_ty - y, -_spd, _spd);
if (abs(x - _tx) < 0.5 && abs(y - _ty) < 0.5) {
    x = _tx; y = _ty; // snap to exact center to avoid float drift
    walk_t = 0;
} else {
    walk_t++;
}

// Update aim direction toward mouse
var _mdx = mouse_x - x;
var _mdy = mouse_y - y;
var _ml  = sqrt(_mdx * _mdx + _mdy * _mdy);
if (_ml > 10) { aim_dx = _mdx / _ml; aim_dy = _mdy / _ml; }

// Stairs detection — checked every frame, triggers on tile match
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
